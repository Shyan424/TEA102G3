<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<div>

			<img src="${memberVO.m_headpic2}" id="headimg">
			<a href="http://localhost:8081/TEA102G3/Front_end/members/MyAccount.jsp"><button type="button" class="btn btn-secondary">
				<i class="fas fa-user-circle" id="icons"></i>我的帳戶
			</button></a>
			<a href="<%=request.getContextPath()%>/orderlist?m_id=${loginId}&action=getMemberAll">
<!--             <a href="http://localhost:8081/TEA102G3/Front_end/members/MyOrder.jsp"> -->
			<button type="button" class="btn btn-secondary">
				<i class="fas fa-clipboard-list" id="icons"></i>購買清單
			</button></a>
			<button type="button" class="btn btn-secondary">
				<i class="fas fa-gamepad" id="icons"></i>租用清單
			</button>
			
			<button type="button" class="btn btn-secondary">
				<i class="fas fa-bell" id="icons"></i>通知總覽
			</button>
			<a href="<%=request.getContextPath()%>/orderlist?m_id=${loginId}&action=getMemberKun">
			<button type="button" class="btn btn-secondary">
				<i class="fas fa-coins" id="icons"></i>我的堃幣
			</button></a>
			
<!-- 	<li> -->
<%--     <FORM METHOD="post" ACTION="<%= request.getContextPath() %>/orderlist" > --%>
<%--         <input type="hidden" name="m_id" value="${loginId}"> --%>
<!--         <input type="hidden" name="action" value="getMemberAll"> -->
<!--         <input type="submit" value="送出"> -->
<!--     </FORM> -->
<!--   </li> -->
		</div>

</body>
</html>