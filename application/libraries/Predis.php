<?php

/*
 * This file is part of the Predis package.
 *
 * (c) Daniele Alessandri <suppakilla@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

require __DIR__ . '/Predis_autoload.php';

define('SESSION_TIME', 4320); // 72 hours
define('AUTHCODE', 'hxM$xRYaur%I0XYsdl6SuJ7*50zYs%W#sS6OxQi');

Class Predis {
	function config() {
		$client = new Predis\Client ([
		    'host' => '127.0.0.1',
		    'port' => 6379,
		    'database' => 0,
			//'password' => AUTHCODE,
			]);
			
		return $client;
	}
}
