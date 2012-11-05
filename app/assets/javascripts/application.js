// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_tree .


$(document).ready(function(){
  $('input.datepicker').datepicker();
});


function remove_fields(link) {
	console.log('remove');
  $(link).prev("input[type=hidden]").val("true");
  $(link).closest(".fields").fadeOut();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
	$(link).parent().prev().hide();
	$(link).parent().prev().fadeIn();
	$(link).parent().prev().find('.account_selector').change(function(){set_investment_company_fields(this)});
}

function set_investment_company_fields(selector) {
	var selected_value = $(selector).find(":selected").text();
	var div = $(selector).closest('.investment_asset_category_plan').find('.401k');
	if (selected_value == '401k/403b' || selected_value == 'Investment Account') {		
		if (selected_value == '401k/403b') {
			$(selector).closest('.investment_asset_category_plan').find('.employer_match').show();
		} else {
			$(selector).closest('.investment_asset_category_plan').find('.employer_match').hide();
		}
		div.show();
	} else {
		div.hide();
	}
}
