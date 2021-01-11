<%@page import="java.util.Iterator"%>
<%@page import="com.member.model.MemberService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List"%>
<%@page import="com.member.model.MemberVO"%>

<%
	String loginId = session.getAttribute("loginId").toString();
	MemberService memberSvc = new MemberService();

	List<MemberVO> memberlist = (List<MemberVO>) memberSvc.getAll();
	for (int i = 0; i < memberlist.size(); i++) {
		if (memberlist.get(i).getM_id().equals(loginId)) {
			memberlist.remove(i);
		}
	}

	pageContext.setAttribute("memberlist", memberlist);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/chatnewg1.css" type="text/css" />
<script
	src="<%=request.getContextPath()%>/vendors/jquery/jquery-3.5.1.min.js"></script>
<style type="text/css">
</style>
<title>KUN聊天室</title>

</head>


<body onload="connect();" onunload="disconnect();">
	<div class="chat_area">
		<div class="chat_icon">
			<img id="only_img"
				src="<%=request.getContextPath()%>/images/chaticon.png" alt=""
				title="聊聊">
		</div>


		<div class="all_div_chat livebox">
			<div class="row">
				<h2><font color=white>${memberVO.m_name}的賣場</font></h2>
				<ul class="memberlist">
					<c:forEach var="memberlist" items="${memberlist}">
						<div id="" class="column" name="friendName"
							value="${memberlist.m_email}">
							<h2>${memberlist.m_name}</h2>
						</div>
					</c:forEach>
				</ul>
			</div>
			<div class="chat_box">
				<div class="statusoutput">
					<div class="membername" id="membername">
						<!--點擊好友後顯示名稱位子-->
					</div>
					<button class="X_btn">X</button>
				</div>
				<div class="chat_message" id="chat_message">
					<!-- 訊息顯示 -->
				</div>
				<div class="inputarea">
					<input type="text" id="message" class="message_input"
						onkeydown="if (event.keyCode == 13) sendMessage();"> 
					<input type="submit" class="submit_btn" value="傳送"
						onclick="sendMessage();"> 
					<input type="hidden" id="friend" value=""> 
					<input type="hidden" class="hiddeninput" value="">				
				</div>
			</div>
		</div>
	</div>

</body>
<script>
	$("#only_img").click(function() {
		$(".chat_icon").addClass("livebox");
		$(".all_div_chat").fadeIn(1000, function() {
			$(".all_div_chat").removeClass("livebox");
		})
	})
	$(".X_btn").click(function() {
		$(".all_div_chat").fadeOut(1000, function() {
			$(".all_div_chat").addClass("livebox");
			$(".chat_icon").removeClass("livebox");
		})

	})
	
	    //以下為webSocket
	var MyPoint = "/FriendWS/${account}";
	var host = window.location.host;
	var path = window.location.pathname;
	var webCtx = path.substring(0, path.indexOf('/', 1));
	var endPointURL = "ws://" + window.location.host + webCtx + MyPoint;
	console.log(endPointURL)
	var statusOutput = document.getElementById("membername");
	var messagesArea = document.getElementById("chat_message");
	var self = '${account}';
	var webSocket;

	function connect() {
		// create a websocket
		webSocket = new WebSocket(endPointURL);

		webSocket.onopen = function(event) {
			console.log("Connect Success!");
		};

		webSocket.onmessage = function(event) {
			//從webSocket中取到值
			var jsonObj = JSON.parse(event.data);
			console.log(jsonObj);
			console.log("chat" === jsonObj.type
					&& $(".hiddeninput").val() == jsonObj.sender)

			if ("open" === jsonObj.type) {
				refreshFriendList(jsonObj);
				var friend = $("#friend").val();
				var jsonObj = {
						"type" : "history",
						"sender" : self,
						"receiver" : friend,
						"message" : ""
					};
				webSocket.send(JSON.stringify(jsonObj));
	
			} else if ("history" === jsonObj.type) {
				messagesArea.innerHTML = '';
				var ul = document.createElement('ul');
				ul.id = "area";
				messagesArea.appendChild(ul);
				// 這行的jsonObj.message是從redis撈出跟好友的歷史訊息，再parse成JSON格式處理
				var messages = JSON.parse(jsonObj.message);
				for (var i = 0; i < messages.length; i++) {
					var historyData = JSON.parse(messages[i]);
					var showMsg = historyData.message;
					var longTime = historyData.time;
					var time = new Date(longTime);
					console.log(time.toLocaleString());
					var li = document.createElement('li');
					var liTime = document.createElement('li');
					// 根據發送者是自己還是對方來給予不同的class名, 以達到訊息左右區分
					historyData.sender === self ? li.className += 'me'
							: li.className += 'friend';
					historyData.sender === self ? liTime.className += 'time_me'
							: liTime.className += 'time_friend';
					li.innerHTML = showMsg;
					liTime.innerHTML = time.toLocaleString();

					ul.appendChild(li);
					ul.appendChild(liTime);
				}
				messagesArea.scrollTop = messagesArea.scrollHeight;
				
			} else if ("chat" === jsonObj.type) {
				var li = document.createElement('li');
				var liTime = document.createElement('li');
				if(jsonObj.sender===$("#friend").val()){
					jsonObj.sender === self ? li.className += 'me' : li.className += 'friend';
					li.innerHTML = jsonObj.message;
					console.log(li);
					document.getElementById("area").appendChild(li);
					messagesArea.scrollTop = messagesArea.scrollHeight;
				}}else{
					let formSender=jsonObj.sender;
					let lis=document.getElementsByClassName("it_is_compy");
					for(let count=0;count<lis.length;count++){
						if($(lis[count])[0].firstChild.textContent===formSender){
							iWantCount(formSender);
							return;
						}
					}
					console.log("你再次被騙了!!!");
					$(".chat_all_compyss").prepend(
							'<li class="it_is_compy" value=' + formSender + '>'
							+formSender
							+'<div class="reminder_div" style="display:none"></div>'
							+'</li>');
					addListener();
					iWantCount(formSender);
				}
				if (jsonObj.sender === self) {
					li.className += 'me'
					liTime.className += 'me'
				}
				if ($(".hiddeninput").val() == jsonObj.sender) {
					li.className += 'friend'
					liTime.className += 'friend'
				}
				var time = new Date(jsonObj.time);
				console.log(time.toLocaleString());
				li.innerHTML = jsonObj.message;
				liTime.innerHTML = time;
				console.log(li);
				console.log(liTime);

				document.getElementById("area").appendChild(li);
				messagesArea.scrollTop = messagesArea.scrollHeight;
			}else if("allCompy"===jsonObj.type){
				refreshFriendList(jsonObj)
			}else if("count"===jsonObj.type){
				let divs=jsonObj.div;
				let lis=document.getElementsByClassName("column");
				for(let count=0;count<lis.length;count++){
					if($(lis[count])[0].firstChild.textContent===jsonObj.receiver){
						addRemind(lis[count],jsonObj.count);
						return;
					}
				}
			}
		};
		
		else if ("close" === jsonObj.type) {
				refreshFriendList(jsonObj);
			}

		};

		webSocket.onclose = function(event) {
			console.log("Disconnected!");
		};
	}
	//訊息傳送
	function sendMessage() {
		var inputMessage = document.getElementById("message");
		// 		var friend = statusOutput.textContent;
		var friend = $(".hiddeninput").val();
		var friend = $("#friend").val();
		var message = inputMessage.value.trim();

		if (message === "") {
			alert("Input a message");
			inputMessage.focus();
		} else if (friend === "") {
			alert("Choose a friend");
		} else {
			var jsonObj = {
				"type" : "chat",
				"sender" : self,
				"receiver" : friend,
				"message" : message,
				"time" : Date.now()
			};
			console.log(jsonObj);

			webSocket.send(JSON.stringify(jsonObj));
			inputMessage.value = "";
			inputMessage.focus();
		}
	}

	// 有好友上線或離線就更新列表
	function refreshFriendList(jsonObj) {
		var friends = jsonObj.users;
		var row = document.getElementById("row");
		var memberlist=document.getElementsByClassName("memberlist")[0];
		for (let i = 0; i < friends.length; i++) {
			if (friends[i] === self) { continue; }
			memberlist.innerHTML +='<li class="column" value="' + friends[i] + '">'
										+friends[i]
										+'<div class="reminder_div" style="display:none"></div>'
										+'</li>';
		}
		addListener();
		for(let i = 0; i < friends.length; i++){
			iWantCount(friends[i]);
		}
	}

	// 註冊列表點擊事件並抓取好友名字以取得歷史訊息
	function addListener() {
		var container = document.getElementById("row");
		// 		container.addEventListener("click", function(e) {
		// 			var friend = e.srcElement.textContent
		$('.column').click(function(e) {
			var friend = e.currentTarget.attributes.value.textContent;
			$(".hiddeninput").val(friend);
			var friend_name = e.currentTarget.children[0].childNodes[0].textContent;
			console.log(e);
			console.log(friend_name);
			updateFriendName(friend_name);
			$("#friend").val(friend);
			var jsonObj = {
				"type" : "history",
				"sender" : self,
				"receiver" : friend,
				"message" : "",
				"time" : Date.now()
			};
			$(this).find(".reminder_div").attr("style","display:none");
            webSocket.send(JSON.stringify(jsonObj));
            removeCount(friend);
        })
	}
		
	// 我要計數器拉
	function iWantCount(formSender){
		var jsonObj={
				"type" : "getMeDiv",
				"sender" : "",
				"receiver" : formSender,
				"message" : ""
		};
		 webSocket.send(JSON.stringify(jsonObj));
	}
	
	//我要加計數器搂
	function addRemind(thisli,count){
		if(count==null){
			return;
		}else{
			$(thisli).find(".reminder_div").attr("style","display:inline-block");
			$(thisli).find(".reminder_div").text(count);
		}
	}
	
	//我要刪計數器拉
	function removeCount(friend){
		var jsonObj={
				"type" : "deleteCount",
				"sender" : "",
				"receiver" : friend,
				"message" : ""
		};
		 webSocket.send(JSON.stringify(jsonObj));
	}
	
	function disconnect() {
		webSocket.close();
	}

	function updateFriendName(name) {
		statusOutput.innerHTML = name;
	}
</script>
</html>