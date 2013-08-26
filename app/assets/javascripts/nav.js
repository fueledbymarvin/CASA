$("document").ready(function() {
	
	//nav
	$(function() {
			$('.navbutton').hover(function(){
				$(this).find('.navhover').animate({height:'0px'},{queue:false,duration:200});
			}, function(){
				$(this).find('.navhover').animate({height:'26px'},{queue:false,duration:200});
			});

			$('.logobutton').hover(function(){
				$(this).find('.logohover').animate({height:'0px'},{queue:false,duration:500});
			}, function(){
				$(this).find('.logohover').animate({height:'180px'},{queue:false,duration:500});
			});
		});

	var pathname = window.location.pathname;

	switch(pathname.substring((pathname.lastIndexOf("/")+1))) {
		case "about":
			$(".navbutton:eq(1)").addClass("navcurrent");
			break;
		case "list":
			$(".navbutton:eq(2)").addClass("navcurrent");
			break;
		case "photos":
			$(".navbutton:eq(3)").addClass("navcurrent");
			break;
		case "":
			$(".navbutton:eq(0)").addClass("navcurrent");
			$("#picbg").css("height", "360px");
			break;
		default:
			$("#picbg").css("display", "none");
	}

	//index header
	$(function() {
		$('.contactbutton').hover(function(){
			$(this).find('.contacthover').animate({height:'0px'},{queue:false,duration:200});
		}, function(){
			$(this).find('.contacthover').animate({height:'40px'},{queue:false,duration:200});
		});
	});

	var int=setInterval(function() { changePic(current); }, 5000);

	var picArray = $(".pic");
	var current = 1;

	function changePic(currentPic) {
		$("#nextpic").off("click");
		var next = (current == picArray.length) ? 1 : (current + 1);
		$("#pic"+current).animate({top: '-360px'}, "normal", function() { $("#pic"+current).css("top", "360px"); });
		$("#pic"+next).animate({top: '0px'}, "normal", function() {
			current = next;
			$("#nextpic").on("click", function () { changePicClick(); });
		});
	}

	function changePicClick() {
		clearInterval(int);
		setTimeout(function() {
			int=setInterval(function() {changePic(current);}, 5000);
		})
		changePic(current);
	}

	$("#nextpic").click(function() { changePicClick(); });

	//determine event section
		var docurl = document.URL;
		var esect = 0;

		switch(docurl.substring((docurl.lastIndexOf("?=")+2))) {
			case "News":
				esect = 1;
				break;
			case "Social":
				esect = 2;
				break;
			case "Cultural":
				esect = 3;
				break;
			case "Community":
				esect = 4;
				break;
			case "Political":
				esect = 5;
				break;
		}

		//event nav
		var eventWidths = new Array();
		for(var i=0; i<$('.eventtype').length; i++)
			eventWidths[i] = $(".eventtype:eq(" + i + ")").width();
		$('.eventtype').each(function(){ $(this).css("width", "0px")});
		$(".eventtype:eq(" + esect + ")").css("width", eventWidths[esect]+"px");

	$(window).load(function() {
		$(".dragon").css("display", "block");

		//other headers
		$(".circle").animate({left: '200px'},750);
		$(".slider").animate({left: '-40px'},750);
		$(".slidercover").animate({left: '240px'},750)	

		//event sections
		var eventHeights = new Array();
		for(var i=0; i<$('.eventsection').length; i++)
			eventHeights[i] = $(".eventsection:eq(" + i + ")").height();
		$('#eventcontainer').css("height", eventHeights[esect]+"px");

		$("#eventcontent").css("margin-left", -900 * esect + "px");

		$(".eventbutton:eq(" + esect + ")").addClass("eventclicked");
		$(".eventbutton").each(function() {

			$(this).click(function() {
				if($(this).hasClass("eventclicked"))
					;
				else {
					for(var i=0; i<$('.eventtype').length; i++) {
						if($(".eventbutton:eq(" + i + ")").hasClass("eventclicked")) {
							$(".eventbutton:eq(" + i + ")").removeClass("eventclicked");
							$(".eventtype:eq(" + i + ")").animate({width:'0px'},{duration:300});
						}	
					}
					$(this).addClass("eventclicked");
					for(var i=0; i<$('.eventtype').length; i++) {
						if($(".eventbutton:eq(" + i + ")").hasClass("eventclicked")) {
							$(".eventtype:eq(" + i + ")").animate({width: eventWidths[i]+"px"},{duration:300});
							$("#eventcontent").animate({marginLeft: (-900 * i) + "px"},{duration:300});
							$("#eventcontainer").animate({height: eventHeights[i] + "px"},{duration:300});
						}
					}
				}
			});
		});
	});

	//board bios
	var bioHeights = new Array();
	for(var i=0; i<$('.boardcontainer').length; i++)
		bioHeights[i] = $(".boardcontainer:eq(" + i + ")").height();
	$('.boardcontainer').each(function(){ $(this).css("height", "0px")});

	$(".member").each(function() {
		$(this).click(function() {
			var index = $(this).index(".member");
			if($(".boardcontainer:eq(" + index + ")").css("height") != "0px")
				$(".boardcontainer:eq(" + index + ")").animate({height: 0 + "px"},{duration:300});
			else {
				$('.boardcontainer').each(function(){ $(this).animate({height: 0 + "px"},{duration:300}) });
				$(".boardcontainer:eq(" + index + ")").animate({height: bioHeights[index] + "px"},{duration:300, complete: function() {
					$('html, body').animate({
				        scrollTop: $(".member:eq(" + index + ")").offset().top
				    }, 300);
				}});
			}
		});
	});

	//four corners
	//Custom settings
    var speed_in = 250;
    var speed_out = 250;    
     
    $('.member').each(function () {
     
    	var neg = Math.round($(this).width() / 2) * (-1);   
	    var pos = neg * (-1);   
	    var out = pos * 2;

        //grab the anchor and image path
        img = $(this).find('img').attr('src');

        //remove the image
        $('img', this).remove();
         
        //append four corners/divs into it
        $(this).append('<div class="topLeft"></div><div class="topRight"></div><div class="bottomLeft"></div><div class="bottomRight"></div>');
         
        //set the background image to all the corners
        $(this).children('div').css('background-image','url('+ img + ')');
 
        //set the position of corners
        $(this).find('div.topLeft').css({top:0, left:0, width:pos , height:pos});   
        $(this).find('div.topRight').css({top:0, left:pos, width:pos , height:pos});    
        $(this).find('div.bottomLeft').css({bottom:0, left:0, width:pos , height:pos}); 
        $(this).find('div.bottomRight').css({bottom:0, left:pos, width:pos , height:pos});  
 
    }).hover(function () {

    	var neg = Math.round($(this).width() / 2) * (-1);   
	    var pos = neg * (-1);   
	    var out = pos * 2;

        //animate the position
        $(this).find('div.topLeft').stop(false, true).animate({top:neg, left:neg}, {duration:speed_out}); 
        $(this).find('div.topRight').stop(false, true).animate({top:neg, left:out}, {duration:speed_out});    
        $(this).find('div.bottomLeft').stop(false, true).animate({bottom:neg, left:neg}, {duration:speed_out});   
        $(this).find('div.bottomRight').stop(false, true).animate({bottom:neg, left:out}, {duration:speed_out});  
                 
    },
     
    function () {

    	var neg = Math.round($(this).width() / 2) * (-1);   
	    var pos = neg * (-1);   
	    var out = pos * 2;
 
        //put corners back to the original position
        $(this).find('div.topLeft').stop(false, true).animate({top:0, left:0}, {duration:speed_in});   
        $(this).find('div.topRight').stop(false, true).animate({top:0, left:pos}, {duration:speed_in});    
        $(this).find('div.bottomLeft').stop(false, true).animate({bottom:0, left:0}, {duration:speed_in}); 
        $(this).find('div.bottomRight').stop(false, true).animate({bottom:0, left:pos}, {duration:speed_in});  
     
    });

	//checkbox form disabling
	if($('#event_hassub').is(':checked')) {
			$("#event_subtitle").prop("disabled", false);
			$(".hsfalse :input").prop("disabled", true);
	}
	else {
			$("#event_subtitle").prop("disabled", true);
			$(".hsfalse :input").prop("disabled", false);
	}

	if($('#event_addend').is(':checked'))
		$(".endtime :input").prop("disabled", false);
	else
		$(".endtime :input").prop("disabled", true);

	$('#event_hassub').click(function() {
		if($(this).is(':checked')) {
			$("#event_subtitle").prop("disabled", false);
			$(".hsfalse :input").prop("disabled", true);
		}
		else {
			$("#event_subtitle").prop("disabled", true);
			$(".hsfalse :input").prop("disabled", false);
			if($('#event_addend').not(':checked'))
				$(".endtime :input").prop("disabled", true);
		}
	});

	$('#event_addend').click(function() {
		if($(this).is(':checked')) 
			$(".endtime :input").prop("disabled", false);
		else
			$(".endtime :input").prop("disabled", true);
	});

	if($('#event_newsletter').is(':checked'))
		$(".newsletter :input").prop("disabled", false);
	else
		$(".newsletter :input").prop("disabled", true);

	$('#event_newsletter').click(function() {
		if($(this).is(':checked')) 
			$(".newsletter :input").prop("disabled", false);
		else
			$(".newsletter :input").prop("disabled", true);
	});

	//rawr change change change

});