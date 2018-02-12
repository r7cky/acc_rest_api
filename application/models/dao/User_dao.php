<?php

if (! defined ( 'BASEPATH' ))
	exit ( 'No direct script access allowed' );
class User_dao extends CI_Model {
	public function __construct() {
		parent::__construct ();
	}
	
	// **GET**
	public function get_user_details_with_email($email) {
		$this->db->select('user__info.user_id');
		$this->db->select('user__info.password');
		$this->db->from('user__info');
		$this->db->where('user__info.email', $email);
		
		$query = $this->db->get();
		return $query->result_array();
	}
	
	public function get_failed_login_attempts_num($user_id) {
		$this->db->select('user__login_attempt.time');
		$this->db->from('user__login_attempt');
		$this->db->where('user__login_attempt.time > DATE_SUB(UTC_TIMESTAMP(), INTERVAL 24 HOUR)');
		$this->db->where('user__login_attempt.time <= UTC_TIMESTAMP()');
		$this->db->where('user__login_attempt.user_id', $user_id);
		$this->db->where('user__login_attempt.successful_login', 0);
		return $this->db->count_all_results();
	}
	
	public function get_session_key_with_user_id($user_id) {
		$this->db->select('user__info.session_key');
		$this->db->from('user__info');
		$this->db->where('user__info.user_id', $user_id);
		
		$query = $this->db->get();
		
		return $query->row()->session_key;
	}
	
	// **UPDATE**
	public function update_user($user_data, $user_id) {
		$this->db->where ('user_id', $user_id);
		$this->db->update ('user__info', $user_data);
		return $this->db->affected_rows();
	}
	
	// **INSERT**
	public function insert_login_attempt($login_data) {
		$this->db->insert('user__login_attempt', $login_data);
		return $this->db->affected_rows() > 0;
	}
	
}
?>