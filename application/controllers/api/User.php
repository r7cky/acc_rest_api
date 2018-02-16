<?php

defined('BASEPATH') OR exit('No direct script access allowed');

// This can be removed if you use __autoload() in config.php OR use Modular Extensions
/** @noinspection PhpIncludeInspection */
require APPPATH . 'libraries/REST_Controller.php';

class User extends REST_Controller {
	
    function __construct() {
        // Construct the parent class
        parent::__construct();
		$this->load->model('user_model');
    }
	
	public function key_with_login_post() {
		$login_info['email'] = $this->post('email');
		$login_info['password'] = $this->post('password');
		$login_info['session_type'] = $this->post('session_type');
		$login_info['ip_address'] = $this->input->ip_address();
		$this->form_validation->set_data($login_info);
		
		$this->form_validation->set_rules('email', 'Email', 'required|valid_email');
		$this->form_validation->set_rules('password', 'Password', 'required');
		$this->form_validation->set_rules('session_type', 'Session Type', 'in_list[admin,teacher]');
		$this->form_validation->set_rules('ip_address', 'IP Address', 'required|valid_ip');
		
		if($this->form_validation->run() == FALSE) {
			$this->response(['status' => FALSE, 'message' => 'An error occured regarding login information', 'errors' => $this->form_validation->error_array()]);
		}else {
			$response_info = $this->user_model->key_with_login($login_info);
			if ($response_info['status'] == TRUE) {
				$this->response(['status' => $response_info['status'], 'message' => $response_info['message'], "session_key" => $response_info['session_key']], REST_Controller::HTTP_OK);
			}else {
				$this->response(['status' => $response_info['status'], 'message' => $response_info['message'], "session_key" => $response_info['session_key']], REST_Controller::HTTP_BAD_REQUEST);
			}
		}
	}
	
	//NEEDS FIXING. PUT MODEL WORK IN MODEL
	public function insert_user_post() {
		$user_form_data['email'] = $this->post('email');
		$user_form_data['password'] = $this->post('password');
		$user_form_data['password_confirmation'] = $this->post('password_confirmation');
		$user_form_data['device_id'] = $this->post('device_id');
		$user_form_data['device_type_id'] = $this->post('device_type_id');
		$user_form_data['first_name'] = $this->post('first_name');
		$user_form_data['last_name'] = $this->post('last_name');
		$this->form_validation->set_data($user_form_data);
		
		//VALIDATE THE DATA
		$this->form_validation->set_rules('email', 'Email', 'required|valid_email|max_length[200]|is_unique[user__info.email]');
		$this->form_validation->set_rules('password', 'Password', 'matches[password_confirmation]|min_length[3]|max_length[40]');
		$this->form_validation->set_rules('password_confirmation', 'Password Confirmation', 'required|matches[password]');
		$this->form_validation->set_rules('device_id', 'Device ID', 'required|max_length[250]');
		$this->form_validation->set_rules('device_type_id', 'Device Type ID', 'required');
		$this->form_validation->set_rules('first_name', 'First Name', 'required|max_length[50]|alpha_numeric');
		$this->form_validation->set_rules('last_name', 'Last Name', 'required|max_length[50]|alpha_numeric');
		if($this->form_validation->run() == FALSE) {
			$this->response(['status' => FALSE, 'message' => 'An error occured regarding login information', 'errors' => $this->form_validation->error_array()]);
		}else {
			$user_data['email'] = $this->post('email');
			$user_data['password'] = $this->post('password');
			$user_data['device_id'] = $this->post('device_id');
			$user_data['device_type_id'] = $this->post('device_type_id');
			$user_data['first_name'] = $this->post('first_name');
			$user_data['last_name'] = $this->post('last_name');
			
			$response_info = $this->user_model->insert_user($user_data);
			if ($response_info['status'] == TRUE) {
				$this->response(['status' => $response_info['status'], 'message' => $response_info['message']], REST_Controller::HTTP_OK);
			}else {
				$this->response(['status' => $response_info['status'], 'message' => $response_info['message']], REST_Controller::HTTP_BAD_REQUEST);
			}
		}
	}
}
