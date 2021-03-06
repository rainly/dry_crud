require 'test_helper'
require File.join(File.dirname(__FILE__), 'crud_controller_test_helper')

class CitiesControllerTest < ActionController::TestCase
  
  include CrudControllerTestHelper
  
  def test_setup
    assert_equal 3, City.count
    assert_recognizes({:controller => 'cities', :action => 'index'}, '/cities')
    assert_recognizes({:controller => 'cities', :action => 'show', :id => '1'}, '/cities/1')
  end
  
  def test_index
    super
    assert_equal 3, assigns(:entries).size
    assert_equal City.order('country_code, name').all, assigns(:entries)
  end
  
  def test_show
    get :show, :id => test_entry.id
    assert_redirected_to_index
  end
  
  def test_destroy_with_inhabitants
    ny = cities(:ny)
    assert_no_difference('City.count') do 
      request.env["HTTP_REFERER"]
      delete :destroy, :id => ny.id
    end
    assert_redirected_to :action => 'show'
    assert flash.alert
  end
  
  protected   
  
  def test_entry
    cities(:rj)
  end
  
  def test_entry_attrs
    {:name => 'Rejkiavik', :country_code => 'IS'}
  end
  
end
