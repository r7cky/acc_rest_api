<?php
if (! defined ( 'BASEPATH' ))
	exit ( 'No direct script access allowed' );
class Predis_model extends CI_Model {
	
	public function __construct() {
		parent::__construct ();
		$this->load->model('dao/predis_dao');
	}
	
	public function insert_session_key_for_user($session_key, $user_id, $session_type) {
	    return $this->predis_dao->insert_session_key_for_user($session_key, $user_id, $session_type);
	}
	
	public function delete_key($key) {
		return $this->predis_dao->delete_key($key);
	}
}
?>