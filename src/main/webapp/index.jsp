<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>员工列表</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- web路径问题 
	不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出现问题。
	以/开始的绝对路径，找资源，以服务器的路径为标准（http://localhost:3306），需要加上项目名
		http://localhost:3306/crud
-->
<script type="text/javascript"
	src="${APP_PATH}/static/js/jquery-1.9.1.min.js"></script>
<link
	href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
	<!-- 员工修改的模态框 -->
	<div class="modal fade" id="empUpdateModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" >员工修改</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			     <p class="form-control-static" id="empName_update_static"></p>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" name="email" id="email_update" placeholder="empName@qq.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">gender</label> 
			    <div class="col-sm-10">
				    <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_update" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_update" value="F"> 女
					</label>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">deptName</label>
			    <div class="col-sm-4">
			    	<!-- 部门提交部门id即可 -->
				   <select class="form-control" name="dId">
					</select>
			    </div>
			  </div>  
			  
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 员工添加的模态框 -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" name="empName" id="empName_input" placeholder="empName">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" class="form-control" name="email" id="email_input" placeholder="empName@qq.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">gender</label> 
			    <div class="col-sm-10">
				    <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_input" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_input" value="F"> 女
					</label>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">deptName</label>
			    <div class="col-sm-4">
			    	<!-- 部门提交部门id即可 -->
				   <select class="form-control" name="dId">
					</select>
			    </div>
			  </div>  
			  
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
	      </div>
	    </div>
	  </div>
	</div>

	<!-- 搭建页面 -->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM_CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button type="button" class="btn btn-primary" id="emp_add_modal_btn">新增</button>
				<button type="button" class="btn btn-danger" id="emp_delete_all_btn">删除</button>
			</div>
		</div>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="check_all"/>
							</th>
							<th>#</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
		<!-- 显示分页数据 -->
		<div class="row">
			<!-- 分页文字信息 -->
			<div class="col-md-6" id="page_info_area"></div>
			<!-- 分页条信息 -->
			<div class="col-md-6" id="page_nav_area"></div>
		</div>
	</div>
	
	
	<script type="text/javascript">
		//保存总记录数,当前页码
		var totalRecord,currentPage;
		//1.页面加载完成以后，直接发送一个ajax请求，要到分页数据
		$(function() {
			//去首页
			to_page(1);
		});
		
		//跳转页面提取方法
		function to_page(pn){
			$.ajax({
				url : "${APP_PATH}/emps",
				data : "pn="+pn,
				type : "GET",
				success : function(result) {
					//1.解析并显示员工数据
					build_emps_table(result);
					//2.解析并显示分页信息
					build_page_info(result);
					//3.解析并显示分页条信息
					build_page_nav(result);
				}
			});
		}

		//解析创建员工列表
		function build_emps_table(result) {
			$("#check_all").prop("checked",false);
			//清空table表格
			$("#emps_table tbody").empty();
			var emps = result.extend.pageInfo.list;
			$.each(emps,function(index, item) {
				var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>")
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(
						item.gender == "M" ? "男" : "女");
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>")
						.append(item.department.deptName);
				//创建按钮
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
					.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
				//为编辑按钮添加一个自定义的属性，表示当前员工的id
				editBtn.attr("edit_id",item.empId);
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
					.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
				//为删除按钮添加一个自定义的属性，表示当前员工的id
				delBtn.attr("del_id",item.empId);
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				//append方法执行完成后还是返回原来的元素
				$("<tr></tr>").append(checkBoxTd).append(empIdTd).append(empNameTd).append(
						genderTd).append(emailTd).append(deptNameTd).append(btnTd)
						.appendTo("#emps_table tbody");				
			});

		}
		
		//解析显示分页信息
		function build_page_info(result){
			//添加前，先清空分页信息区域
			$("#page_info_area").empty();
			$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页，总"
					+result.extend.pageInfo.pages+"页，总"+result.extend.pageInfo.total+"条记录");
			totalRecord = result.extend.pageInfo.total;
			currentPage = result.extend.pageInfo.pageNum;
		}
		
		//解析显示分页条,点击分页进行跳转
		function build_page_nav(result){
			//添加前先清空分页显示区域
			$("#page_nav_area").empty();
			//page_nav_area
			//构建元素
			var ul = $("<ul></ul>").addClass("pagination");
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页"));
			var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			//如果没有之前页码，前一页与首页不可点击
			if(result.extend.pageInfo.hasPreviousPage == false){
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}else{
				//为元素添加点击翻页事件
				firstPageLi.click(function(){
					to_page(1);
				});
				prePageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum-1)
				});
			}

			
			var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			var lastPageLi = $("<li></li>").append($("<a></a>").append("末页"));
			//如果没有之后页码，后一页与末页不可点击
			if(result.extend.pageInfo.hasNextPage == false){
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			}else{
				//为元素添加点击翻页事件
				lastPageLi.click(function(){
					to_page(result.extend.pageInfo.pages);
				});
				nextPageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum+1)
				});
			}
			
			ul.append(firstPageLi).append(prePageLi);
			
			$.each(result.extend.pageInfo.navigatepageNums,function(index,item){
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				//如果页号为当前页，不可点击并且高亮
				if(result.extend.pageInfo.pageNum == item){
					numLi.addClass("active");
				}else{
					numLi.click(function(){
						to_page(item);
					});
				}
				ul.append(numLi);
			});
			
			ul.append(nextPageLi).append(lastPageLi);
			
			var nav = $("<nav></nav>").append(ul);
			nav.appendTo("#page_nav_area");
		}
		
		//清空表单样式及其内容
		function reset_form(ele){
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-success has-error");
			$(ele).find(".help-block").text("");
		}
		
		//点击新增按钮弹出模态框
		$("#emp_add_modal_btn").click(function(){
			//清除表单数据(表单重置，样式也需要重置),转换为dom对象调用reset方法
			reset_form("#empAddModal form");
			//发送ajax请求，查出部门信息，显示在下拉列表
			getDepts("#empAddModal select");
			//弹出模态框
			$("#empAddModal").modal({
				backdrop:"static"
			});
		});
		
		//查询所有部门的ajax方法
		function getDepts(ele){
			//清空下拉列表里面的内容
			$(ele).empty();
			$.ajax({
				url:"${APP_PATH}/depts",
				type:"GET",
				success:function(result){
					//{"code":100,"msg":"操作成功！","extend":{"depts":[{"deptId":1,"deptName":"开发部"},{"deptId":2,"deptName":"技术部"}]}}
					$.each(result.extend.depts,function(){
						var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
						$(ele).append(optionEle);
					});
				}
			});			
		}
		
		//校验用户名是否重复可用
		$("#empName_input").change(function(){
			//发送ajax请求校验用户名是否可用
			var empName = this.value;
			$.ajax({
				url:"${APP_PATH}/checkuser",
				data:"empName="+empName,
				type:"POST",
				success:function(result){
					if(result.code == 100){
						show_validate_msg("#empName_input","success","用户名可用");
						//用一个参数ajax_va来保存用户名校验的状态
						$("#emp_save_btn").attr("ajax_va","success");
					}else{
						show_validate_msg("#empName_input","error",result.extend.va_msg);
						$("#emp_save_btn").attr("ajax_va","error");
					}
				}
			});
		});
		
		//点击保存，保存员工
		$("#emp_save_btn").click(function(){
			//1.模态框中填写的表单数据提交给服务器进行保存
			//2.先对要提交给服务器的数据进行校验(前端校验)
			if(!validate_add_form()){
				return false;
			};
			//3.判断之前发送的ajax用户名校验是否成功
			if($(this).attr("ajax_va")=="error"){
				return false;
			}
			//4.发送ajax请求保存员工
			$.ajax({
				url:"${APP_PATH}/emp",
				type:"POST",
				data:$("#empAddModal form").serialize(),
				success:function(result){
					//alert(result.msg);
					//后端校验的判断
					if(result.code == 100){
						//员工保存成功
						//1.关闭模态框
						$("#empAddModal").modal('hide');
						
						//2.来到最后一页显示刚才保存的数据
						//发送ajax请求显示最后一页数据即可
						to_page(totalRecord);
					}else{
						//显示失败信息		
						//有哪个字段的错误信息就显示哪个字段的
						if(undefined != result.extend.errorFields.email){
							//显示邮箱错误信息
							show_validate_msg("#email_input","error",result.extend.errorFields.email);
						}
						if(undefined != result.extend.errorFields.empName){
							//显示员工错误信息
							show_validate_msg("#empName_input","error",result.extend.errorFields.empName);
						}
					}
				}
			});
		});
		
		//校验表单数据
		function validate_add_form(){
			//1.拿到药校验的数据，使用正则表达式
			var empName = $("#empName_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if(!regName.test(empName)){
				//alert("用户名可以是2-5位中文或6-16位英文和数字的组合");
				show_validate_msg("#empName_input","error","用户名可以是2-5位中文或6-16位英文和数字的组合");
				return false;
			}else if($("#emp_save_btn").attr("ajax_va") == "error"){
				show_validate_msg("#empName_input","error","用户名重复");
			}else{
				show_validate_msg("#empName_input","success","");
			}
			
			//2.校验邮箱地址
			var email = $("#email_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				//alert("邮箱格式错误");
				show_validate_msg("#email_input","error","邮箱格式错误");
				return false;
			}else{
				show_validate_msg("#email_input","success","");
			}
			return true;
		}
		
		//显示当前元素的校验状态以及提示信息
		function show_validate_msg(ele,status,msg){
			//清除当前元素的校验状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			if("success" == status){
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			}else if("error" == status){
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		
		//用on绑定之后创建的元素的click事件
		$(document).on("click",".edit_btn",function(){
			//1.查出部门信息，并显示部门列表
			getDepts("#empUpdateModel select");
			//2.查出员工信息，显示员工信息
			getEmp($(this).attr("edit_id"));
			
			//3.把员工的id传递给模态框的更新按钮
			$("#emp_update_btn").attr("edit_id",$(this).attr("edit_id"));
			
			$("#empUpdateModel").modal({
				backdrop:"static"
			});
		});
		
		//根据指定empId,查出员工信息
		function getEmp(id){
			$.ajax({
				url:"${APP_PATH}/emp/"+id,
				type:"GET",
				success:function(result){
					$("#empName_update_static").text(result.extend.emp.empName);
					$("#email_update").val(result.extend.emp.email);
					$("#empUpdateModel input[name=gender]").val([result.extend.emp.gender]);
					$("#empUpdateModel select").val([result.extend.emp.dId]);
				}
			});
		}
		
		//点击更新保存员工信息
		$("#emp_update_btn").click(function(){
			//验证邮箱合法
			var email = $("#email_update").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				show_validate_msg("#email_update","error","邮箱格式错误");
				return false;
			}else{
				show_validate_msg("#email_update","success","");
			}
			
			//发送ajax请求保存
			//需要支持PUT请求，tomcat只有在POST请求情况下才能把数据封装Map,
			//SpringMVC若要直接支持PUT请求需要多配一个拦截器（HttpPutFormContentFilter）
			$.ajax({
				url:"${APP_PATH}/emp/"+$(this).attr("edit_id"),
				type:"PUT",
				data:$("#empUpdateModel form").serialize(), 
				success:function(result){
					//alert(result.msg);
					//1.关闭模态框
					$("#empUpdateModel").modal("hide");
					//2.回到本页面
					to_page(currentPage);
				}
			});
		});
		
		//为单个删除按钮绑定点击事件
		$(document).on("click",".delete_btn",function(){
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			var empId = $(this).attr("del_id");
			//判断是否删除	
			if(confirm("确认删除【"+empName+"】吗？")){
				//发送ajax请求删除数据
				$.ajax({
					url:"${APP_PATH}/emp/"+empId,
					type:"DELETE",
					success:function(result){
						//alert(result.msg);	
						
						//发送ajax请求到当前页面
						to_page(currentPage);
					}
				});
			}	
		});
		
		//完成全选和全不选
		$("#check_all").click(function(){
			//我们这些dom原生属性用prop获取，自定义属性用attr获取
			//prop修改和读取dom原生属性的值
			$(".check_item").prop("checked",$(this).prop("checked"));		
		});
		
		//check_item绑定单击事件
		$(document).on("click",".check_item",function(){
			//选中的个数是否等于所有class为check_item的个数 
			var flag = $(".check_item:checked").length==$(".check_item").length;
			$("#check_all").prop("checked",flag);
		});
		
		//点击全部删除，就批量删除
		$("#emp_delete_all_btn").click(function(){
			
			//遍历每一个选中的checkbox
			var empNames = "";
			var empIds = "";
			$.each($(".check_item:checked"),function(){
				empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
				//组装员工id字符串
				empIds += $(this).parents("tr").find("td:eq(1)").text()+"-";
			});
			//去除多余的分隔符
			empNames = empNames.substring(0,empNames.length-1);
			empIds = empIds.substring(0,empIds.length-1);
			if(confirm("确认删除【"+empNames+"】吗？")){
				//发送ajax请求删除				
				$.ajax({
					url:"${APP_PATH}/emp/"+empIds,
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						//回到当前页面
						to_page(currentPage);
					}
				});
			}
		});
		
	</script>
</body>
</html>