<?php
/**
 * Static content controller.
 *
 * This file will render views from views/pages/
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.Controller
 * @since         CakePHP(tm) v 0.2.9
 * @license       http://www.opensource.org/licenses/mit-license.php MIT License
 */

App::uses('AppController', 'Controller');

/**
 * Static content controller
 *
 * Override this controller by placing a copy in controllers directory of an application
 *
 * @package       app.Controller
 * @link http://book.cakephp.org/2.0/en/controllers/pages-controller.html
 */
class PagesController extends AppController {

/**
 * This controller does not use a model
 *
 * @var array
 */
	public $uses = array();
	public $uses2 = array();
	public $uses3 = array();

/**
 * TooManyMethods
*/
public function display1() {
}
public function display2() {
}
public function display3() {
}
public function display4() {
}
public function display5() {
}
public function display6() {
}
public function display7() {
}
public function display8() {
}
public function display9() {
}
public function display10() {
}
public function display11() {
}
public function display12() {
}
public function display13() {
}
public function display14() {
}
public function display15() {
}
public function display16() {
}
public function display17() {
}

/**
 * Displays a view
 *
 * @return void
 * @throws NotFoundException When the view file could not be found
 *	or MissingViewException in debug mode.
 */
	public function display() {
    $eeeeeeeeee;
    $aaaaaaaaaa;
    $bbbbbbbbbb;
    $aaaaaaaaaa;

    $cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc;
		$path = func_get_args();

		$count = count($path);
		if (!$count) {
			return $this->redirect('/');
		}
		$page = $subpage = $title_for_layout = null;

		if (!empty($path[0])) {
			$page = $path[0];
		}
		if (!empty($path[1])) {
			$subpage = $path[1];
		}
		if (!empty($path[$count - 1])) {
			$title_for_layout = Inflector::humanize($path[$count - 1]);
		}
		$this->set(compact('page', 'subpage', 'title_for_layout'));

		try {
			$this->render(implode('/', $path));
		} catch (MissingViewException $e) {
			if (Configure::read('debug')) {
				throw $e;
			}
			throw new NotFoundException();
		}
  }

  private $顧客名;

  function set顧客名($v)
  {
    $this->顧客名 = $v;
    return $this;
  }

  function get顧客名()
  {
    return $this->顧客名;
  }
}

/**
 * CyclomaticComplexity
 */
// Cyclomatic Complexity = 12
class Foo {
    public function example()  {
        if ($a == $b)  {
            if ($a1 == $b1) {
                fiddle();
            } else if ($a2 == $b2) {
                fiddle();
            }  else {
                fiddle();
            }
        } else if ($c == $d) {
            while ($c == $d) {
                fiddle();
            }
         } else if ($e == $f) {
            for ($n = 0; $n < $h; $n++) {
                fiddle();
            }
        } else{
            switch ($z) {
                case 1:
                    fiddle();
                    break;
                case 2:
                    fiddle();
                    break;
                case 3:
                    fiddle();
                    break;
                default:
                    fiddle();
                    break;
            }
        }
    }
}
