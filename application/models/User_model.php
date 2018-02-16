<?php

if (! defined ( 'BASEPATH' ))
	exit ( 'No direct script access allowed' );
class User_model extends CI_Model {
	public function __construct() {
		parent::__construct ();
		
		$this->load->model('dao/user_dao');
		$this->load->model('predis_model');
	}
	
	public function insert_user($user_data) {
		//hash the password before continuing
		$user_data['password'] = password_hash($user_data['password'], PASSWORD_DEFAULT);
		
		//removes blank data
		foreach ($user_data as $key => $value) {
			if (empty($value)) {
				$array = array(
					"status" => FALSE,
					'message' => 'Please enter all values for user registration',
				);
			
				return $array;
			}
		}
		
		$this->db->trans_start();
		//$user_data['error_test'] = 0;
		$inserted_user_id = $this->user_dao->insert_user($user_data);
		$this->db->trans_complete();
		$is_insert_success = $this->db->trans_status();
		
		if ($is_insert_success) {
			$this->db->trans_commit();
			
			$array = array(
				"status" => TRUE,
				'message' => 'User successfuly registered',
			);
			return $array;
		}else {
			$this->db->trans_rollback();
			
			$array = array(
				"status" => FALSE,
				'message' => 'Error occured inserting user into database. Please contact admin',
			);
			return $array;
		}
	}
	
	public function key_with_login($login_info) {
		//extracting info from array
		$email = $login_info['email'];
		$unhashed_password = $login_info['password'];
		$session_type = $login_info['session_type'];
		$ip_address = $login_info['ip_address'];
		
		$max_logins = 100;
		
		//error messages
		$invalid_session_messsage = "Invalid session type";
		$bad_login_message = "Wrong email or password";
		$max_failed_logins_message = "Max amount of failed logins reached in the past 24 hours";
		$reason_string_success = "Successful login without existing session";
		
		//gets the user details and checks if its empty
		$user_details = $this->user_dao->get_user_details_with_email($email);
		if (empty($user_details)) {
			return $this->user_model->login_array_contents(FALSE, $bad_login_message, NULL);
		}
		$user_id = $user_details[0]['user_id'];
		
		//checks if failed logins have reached the limit for the past 24 hours
		$failed_logins = $this->user_dao->get_failed_login_attempts_num($user_id);
		if ($failed_logins >= $max_logins) {
			//log the failed login
			$this->user_model->insert_login_attempt($ip_address, $user_id, 0, "Max amount of failed logins reached");
			return $this->user_model->login_array_contents(FALSE, $max_failed_logins_message, NULL);
		}
		
		//checks if password is invalid
		$is_password_valid = password_verify($unhashed_password, $user_details[0]['password']);
		if (!$is_password_valid) {
			//log the failed login
			$this->user_model->insert_login_attempt($ip_address, $user_id, 0, "Wrong password");
			return $this->user_model->login_array_contents(FALSE, $bad_login_message, NULL);
		}
		
		//get the current session to delete it within the redis DB
		$current_session_key = $this->user_dao->get_session_key_with_user_id($user_id);
		if (!empty($current_session_key)) {
			$this->predis_model->delete_key($current_session_key);
		}
		
		//temp api key = current time + email
		$new_session_key = md5(microtime().rand() . $email);
		$new_session_key = $this->predis_model->insert_session_key_for_user($new_session_key, $user_id, $session_type);
		
		//set api key in user__info in database to verify in the future
		$user_data['session_key'] = $new_session_key;
		$this->user_dao->update_user($user_data, $user_id);
		
		//log the successful login
		$this->user_model->insert_login_attempt($ip_address, $user_id, 1, $reason_string_success);
		
		return $this->user_model->login_array_contents(TRUE, "Session key created", $new_session_key);
	}
	
	private function insert_login_attempt($ip_address, $user_id, $successful_login, $reason_string) {
		//for inserting login attempt
		date_default_timezone_set('UTC');
		$date = date ('Y-m-d H:i:s');
		
		$login_attempt = array(
			"ip_address" => $ip_address,
			"user_id" => $user_id,
			"time" => $date,
			"successful_login" => $successful_login,
			"reason" => $reason_string,
		);
		
		$this->user_dao->insert_login_attempt($login_attempt);
	}
	
	private function login_array_contents($status, $message, $session_key) {
		$array = array(
			"status" => $status,
			"message" => $message,
			"session_key" => $session_key,
		);
		
		return $array;
	}
}
?>