<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="BIG5">
	<title>Insert title here</title>
	<link rel="stylesheet" href="<%=request.getContextPath()%>/vendors/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet type" href="<%=request.getContextPath()%>/Back_end/employee/css/index_backstage.css">
</head>
<body>
	<div class="container update_without">
        <div class="row">
            <div class="col">
                <p>原有密碼:</p>
            </div>
            <div class="col">
                <input type="password" name="origin_password">
            </div>
        </div>
        <div class="row">
            <div class="col">
                <p>新密碼:</p>
            </div>
            <div class="col">
                <input type="password" name="new_password">
            </div>
        </div>
        <div class="row">
            <div class="col">
                <p>密碼確認:</p>
            </div>
            <div class="col">
                <input type="password" name="check_password">
            </div>
        </div>
        <div class="row forget-row">
            <div class="col btn_col">
                <button type="submit" class="btn btn-primary forget-btn">確認</button>
                <input type="hidden" name="action" value="update_pwd">
				<input type="hidden" name="e_id" value="${employeeVO.e_id}">
            </div>
        </div>
    </div>
    
    
    
    <script src="<%=request.getContextPath()%>/vendors/jquery/jquery-3.5.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/vendors/popper/popper.min.js"></script>
    <script src="<%=request.getContextPath()%>/vendors/bootstrap/js/bootstrap.min.js"></script>
    <script src="<%=request.getContextPath()%>/Back_end/employee/js/index_backstage.js"></script>
</body>
</html>