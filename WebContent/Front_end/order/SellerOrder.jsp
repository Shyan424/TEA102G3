<%@page import="com.qrcode.OrderListQRCodeCreate"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.product.model.ProductVO"%>
<%@page import="com.product.model.ProductService"%>
<%@page import="com.orderlist.model.OrderlistVO"%>
<%@page import="com.orderlist.model.OrderlistService"%>
<%@page import="com.member.model.MemberService"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="redis.clients.jedis.Jedis"%>
<%@page import="java.util.List"%>
<%@page import="com.orderdetail.model.*"%>
<%@page import="com.member.model.MemberVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
%>


<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<title>YuXiKun</title>


<style>
.mybody {
	background-color: #E3F8F6;
}

.myform {
	border: 1px solid gray;
	background-color: rgb(243, 241, 241);
	width: 400px;
	height: 300px;
	text-align: center;
	margin: 20px auto;
}

.topcol {
	width: auto;
	height: 80px;
	background-color: #6CCFF3;
	margin: 0px 0px 20px 0px;
	font-size: 24px;
}

#inputEmail3 {
	width: 300px;
}

#inputPassword3 {
	width: 300px;
	margin-bottom: 5px;
}



#icons {
	left: 0px;
}

#headimg {
	width: 200px;
	height: 200px;
	border-radius: 50%;
	margin-right: 20px;
}

 #pills-home-tab, #pills-profile-tab, #pills-contact-tab, #pills-4-tab, #pills-5-tab{ 
     text-align: center; 
     margin: auto; 
     position: relative; 
     left: 50%; 
     font-size: 20px; 
     padding: 15px 50px; 
 } 

#pills-tab{
    margin:auto;
    width:950px;
}

#changepw{
    height:300px;
}

#revise{
    background-color: #FFA000;
    width: 100px;
    border: 1px solid #707070;
    margin-left: 20px;
}
#order{
    margin: auto;
}
.card{
    margin: auto;
    width: 800px;
    text-align:left;
}
h5.card-header {
    background-color: #cce5ff;
}
.btn btn-primary{
    text-align:right;

}

</style>



</head>


<body style="background:#F5D2CD;
	height: 100%;">
	
	
<div class="header">
	<jsp:include page="../header.jsp"></jsp:include>
</div>

	<div class="content">
	
	<div>
		<jsp:include page="../index_Seller_Buttongroup.jsp"></jsp:include>
	</div>
	
	<div>
	<!--Nav bar區域-->
<ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
  <li class="nav-item" role="presentation">
    <a class="nav-link active" id="pills-home-tab" data-toggle="pill" href="#pills-home" role="tab" aria-controls="pills-home" aria-selected="true">全部</a>
  </li>
  <li class="nav-item" role="presentation">
    <a class="nav-link" id="pills-profile-tab" data-toggle="pill" href="#pills-profile" role="tab" aria-controls="pills-profile" aria-selected="false">訂單成立</a>
  </li>
  <li class="nav-item" role="presentation">
    <a class="nav-link" id="pills-contact-tab" data-toggle="pill" href="#pills-contact" role="tab" aria-controls="pills-contact" aria-selected="false">已出貨</a>
  </li>
  <li class="nav-item" role="presentation">
    <a class="nav-link" id="pills-4-tab" data-toggle="pill" href="#pills-4" role="tab" aria-controls="pills-4" aria-selected="false">已到貨</a>
  </li>
    <li class="nav-item" role="presentation">
    <a class="nav-link" id="pills-5-tab" data-toggle="pill" href="#pills-5" role="tab" aria-controls="pills-5" aria-selected="false">訂單完成</a>
  </li>
  
</ul>


<!--內容區域 -->


<!-- 全部 -->
<div class="tab-content" id="pills-tabContent">
  <div class="tab-pane fade show active" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab">
  
  <table id="order">

	<c:forEach var="orderlistVO" items="${sellerorder}">

				<div class="card">
					<h5 class="card-header">訂單編號: ${orderlistVO.o_id}</h5>
					<div class="card-body">
					    <h5 class="card-title">訂單成立: ${orderlistVO.o_dateForm}</h5>
						<h5 class="card-title">訂單狀態: ${orderlistVO.o_status}</h5>
						<h5 class="card-title">總金額: ${orderlistVO.o_total}</h5>
						
						<%
						OrderlistVO orderlistVO = (OrderlistVO)pageContext.getAttribute("orderlistVO");
						String o_id = orderlistVO.getO_id();
						String o_status = orderlistVO.getO_status();
						Boolean shipOrNot;
						if(o_status.equals("已出貨")){
							shipOrNot=true;
						}else{
							shipOrNot=false;
						}
						System.out.println(shipOrNot);
                        String hostString = request.getServerName() + ":" + request.getServerPort();
                        OrderListQRCodeCreate qr = new OrderListQRCodeCreate();
                        String qrcode=qr.creater(hostString,o_id);
						
						%>
						
						<c:if test="<%=shipOrNot%>">
						<p>以下是您的出貨QRcode:</p>
                        <img src="data:image/jpg;base64,<%=qrcode%>" style="width:100px; height: 100px;"/>
						
						</c:if>
						
						<FORM METHOD="post" ACTION="<%=request.getContextPath()%>/OrderdetailServlet"  target="_blank" class="detail">
			            <input type="submit" value="詳情" class="btn btn-primary">
			            <input type="hidden" name="o_id"  value="${orderlistVO.o_id}">
			            <input type="hidden" name="action"	value="getOrderDetailByOrder"></FORM>
						
						
					</div>
				</div>

			</c:forEach>
			
     </table>    
  </div>
  
  <!--新訂單區域  -->
  <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab">
  
	<c:forEach var="orderlistVO" items="${neworder}">

				<div class="card">
					<h5 class="card-header">訂單編號: ${orderlistVO.o_id}</h5>
					<div class="card-body">
					<h5 class="card-title">訂單成立: ${orderlistVO.o_dateForm}</h5>
						<h5 class="card-title">訂單狀態: ${orderlistVO.o_status}</h5>
						<h5 class="card-title">總金額: ${orderlistVO.o_total}</h5>
						
						<FORM METHOD="post" ACTION="<%=request.getContextPath()%>/OrderdetailServlet"  target="_blank" class="detail">
			            <input type="submit" value="詳情" class="btn btn-primary">
			            <input type="hidden" name="o_id"  value="${orderlistVO.o_id}">
			            <input type="hidden" name="action"	value="getOrderDetailByOrder"></FORM>
						
						
					</div>
				</div>

			</c:forEach>
  
  </div>
  
  <!-- 寄出訂單區域 -->
  <div class="tab-pane fade" id="pills-contact" role="tabpanel" aria-labelledby="pills-contact-tab">
	<c:forEach var="orderlistVO" items="${sentorder}">
	
				<div class="card">
					<h5 class="card-header">訂單編號: ${orderlistVO.o_id}</h5>
					<div class="card-body">
					<h5 class="card-title">訂單成立: ${orderlistVO.o_dateForm}</h5>
						<h5 class="card-title">訂單狀態: ${orderlistVO.o_status}</h5>
						<h5 class="card-title">總金額: ${orderlistVO.o_total}</h5>
						
						<% 
						OrderlistVO orderlistVO = (OrderlistVO)pageContext.getAttribute("orderlistVO");
						String o_id=orderlistVO.getO_id();
                        String hostString = request.getServerName() + ":" + request.getServerPort();
                        OrderListQRCodeCreate qr = new OrderListQRCodeCreate(); 
                        String qrcode=qr.creater(hostString,o_id );
                        %>
                        <p>以下是您的出貨QRcode:</p>
                        <img src="data:image/jpg;base64,<%=qrcode%>" style="width:100px; height: 100px;"/>
						
						
						<FORM METHOD="post" ACTION="<%=request.getContextPath()%>/OrderdetailServlet"  target="_blank" class="detail">
			            <input type="submit" value="詳情" class="btn btn-primary">
			            <input type="hidden" name="o_id"  value="${orderlistVO.o_id}">
			            <input type="hidden" name="action"	value="getOrderDetailByOrder"></FORM>						
						
					</div>
				</div>

			</c:forEach>
  
  </div>
  
  <!--到貨訂單區域-->
  <div class="tab-pane fade" id="pills-4" role="tabpanel" aria-labelledby="pills-4-tab">
  
	<c:forEach var="orderlistVO" items="${arrivedorder}">
	
				<div class="card">
					<h5 class="card-header">訂單編號: ${orderlistVO.o_id}</h5>
					<div class="card-body">
					<h5 class="card-title">訂單成立: ${orderlistVO.o_dateForm}</h5>
						<h5 class="card-title">訂單狀態: ${orderlistVO.o_status}</h5>
						<h5 class="card-title">總金額: ${orderlistVO.o_total}</h5>
						
						<FORM METHOD="post" ACTION="<%=request.getContextPath()%>/OrderdetailServlet"  target="_blank" class="detail">
			            <input type="submit" value="詳情" class="btn btn-primary">
			            <input type="hidden" name="o_id"  value="${orderlistVO.o_id}">
			            <input type="hidden" name="action"	value="getOrderDetailByOrder"></FORM>						

					</div>
				</div>

			</c:forEach>
  
  
  </div>
  
  <!-- 已完成訂單區域 -->
  <div class="tab-pane fade" id="pills-5" role="tabpanel" aria-labelledby="pills-5-tab">
  
	<c:forEach var="orderlistVO" items="${finishorder}">
	
				<div class="card">
					<h5 class="card-header">訂單編號: ${orderlistVO.o_id}</h5>
					<div class="card-body">
					<h5 class="card-title">訂單成立: ${orderlistVO.o_dateForm}</h5>
						<h5 class="card-title">訂單狀態: ${orderlistVO.o_status}</h5>
						<h5 class="card-title">總金額: ${orderlistVO.o_total}</h5>
						
						<FORM METHOD="post" ACTION="<%=request.getContextPath()%>/OrderdetailServlet"  target="_blank" class="detail">
			            <input type="submit" value="詳情" class="btn btn-primary">
			            <input type="hidden" name="o_id"  value="${orderlistVO.o_id}">
			            <input type="hidden" name="action"	value="getOrderDetailByOrder"></FORM>						
						
					</div>
				</div>

			</c:forEach>	
  
  </div>
  
  
</div>
	
	
	
	
	
	
	
	
	</div>
	
	

</div>
	<div class="footer">
		<jsp:include page="../footer.jsp"></jsp:include>
	</div>



</body>

</html>