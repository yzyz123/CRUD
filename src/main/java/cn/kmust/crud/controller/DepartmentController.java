package cn.kmust.crud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.kmust.crud.bean.Department;
import cn.kmust.crud.bean.Message;
import cn.kmust.crud.service.DepartmentService;

@Controller
public class DepartmentController {

	@Autowired
	DepartmentService departmentService;
	
	@RequestMapping("/depts")
	@ResponseBody
	public Message getDepts() {
		List<Department> depts = departmentService.getDepts();
		return Message.success().add("depts",depts);
	}
	
}
