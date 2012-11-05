require 'test_helper'

class InvestmentPlansControllerTest < ActionController::TestCase
  setup do
    @investment_plan = investment_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:investment_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create investment_plan" do
    assert_difference('InvestmentPlan.count') do
      post :create, :investment_plan => @investment_plan.attributes
    end

    assert_redirected_to investment_plan_path(assigns(:investment_plan))
  end

  test "should show investment_plan" do
    get :show, :id => @investment_plan.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @investment_plan.to_param
    assert_response :success
  end

  test "should update investment_plan" do
    put :update, :id => @investment_plan.to_param, :investment_plan => @investment_plan.attributes
    assert_redirected_to investment_plan_path(assigns(:investment_plan))
  end

  test "should destroy investment_plan" do
    assert_difference('InvestmentPlan.count', -1) do
      delete :destroy, :id => @investment_plan.to_param
    end

    assert_redirected_to investment_plans_path
  end
end
