<?php

class Sample extends WP_UnitTestCase {

	public function test_is_wp() {
		$this->assertTrue( method_exists( 'esc_html' ) );
	}

}
