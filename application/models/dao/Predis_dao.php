<?php
if (! defined ( 'BASEPATH' ))
	exit ( 'No direct script access allowed' );
class Predis_dao extends CI_Model {
	private const ACC_TAG = 'ACC:';
	private const SESSION_TAG = Predis_dao::ACC_TAG . 'Session:';
	
	//LOADING PREDIS IN EVERY METHOD! FIX THIS
	public function __construct() {
		parent::__construct ();
		$this->load->library('predis');
	}
	
	// **INSERT**
	public function insert_session_key_for_user($session_key, $user_id, $session_type) {
		$predis = $this->predis->config();
		$predis_key = Predis_dao::SESSION_TAG . $session_key;
		
		$value_contents['user_id'] = $user_id;
		$value_contents['session_type'] = $session_type;
		
		//set api key as the key and the user id as the value
	    $predis->hmset($predis_key, $value_contents);
	    $predis->expire($predis_key, SESSION_TIME);
		
		return $predis_key;
	}
	
	// **DELETE**
	public function delete_key($key) {
		$predis = $this->predis->config();
		
		return $predis->del($key);
	}
}
?>