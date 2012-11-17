// JavaScript Document

$(document).ready(function(){
	//左侧导航js
	var $nav = $('ul.leftnav li');
	var $twobox = $nav.find('.twobox');
	var $twoboxNav = $twobox.find('a');
	var leftNavOperate = function(index){
		$nav.removeClass('current');
		index.siblings().find('.twobox').slideUp();
		index.addClass('current');
		index.find('.twobox').slideDown();
		return false;
	}
	$nav.click(function(){
		leftNavOperate($(this));
	});
	$twoboxNav.click(function(event){
		event.stopPropagation();
		$twoboxNav.removeClass('current');
		$(this).addClass('current');
	});
	$('ul.leftnav li a.hasTh').click(function(){
		$(this).next('.thbox').toggle();
	});
})