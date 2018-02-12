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
}
