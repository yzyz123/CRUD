package cn.kmust.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import cn.kmust.crud.bean.Employee;
import cn.kmust.crud.bean.Message;
import cn.kmust.crud.service.EmployeeService;

@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;
	
	/**
	 * 用户名校验
	 * @param empName
	 * @return 
	 */
	@RequestMapping("/checkuser")
	@ResponseBody
	public Message checkuser(@RequestParam("empName")String empName) {
		//后端校验
		//先判断用户名是否合法的表达式；
		//java中正则表达式中的\为特殊字符(转义字符)，需要改成\\
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
		if(!empName.matches(regx)) {
			return Message.fail().add("va_msg", "用户名必须是2-5位中文或6-16位英文和数字的组合");
		}
		
		//数据库用户名重复校验
		boolean b = employeeService.checkUser(empName);
		if(b) {
			return Message.success();
		}else {
			return Message.fail().add("va_msg", "用户名重复");
		}
	}
	
	/**
	 * 员工删除
	 * 单个批量二合一
	 * 批量删除：1-2-3
	 * 单个删除：1
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	@ResponseBody
	public Message deleteEmp(@PathVariable("ids")String ids) {
		if(ids.contains("-")) {
			List<Integer> del_ids = new ArrayList<Integer>();
			//批量删除
			String[] str_ids = ids.split("-");
			//组装id的集合
			for (String id : str_ids) {
				del_ids.add(Integer.parseInt(id));
			}
			employeeService.deleteBatch(del_ids);
		}else {
			//单个删除
			Integer id = Integer.parseInt(ids);
			employeeService.deleteEmp(id);
		}
		return Message.success();
	}
	
	/**
	 * 员工更新方法 
	 * 我们要能支持直接发送PUT之类的请求还要封装请求体中的数据：
	 * 解决方案：
	 * 1.配置上HttpPutFormContentFilter；
	 * 2.它的作用：将请求体中的数据解析包装成一个map
	 * 3.request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据
	 * 员工更新方法
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Message updateEmp(Employee employee) {
		employeeService.updateEmp(employee);
		return Message.success();
	}
	
	/**
	 * 根据主键id获取某个员工
	 * @param empId
	 * @return
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.GET)
	@ResponseBody
	public Message getEmp(@PathVariable("empId")Integer empId) {
		Employee employee = employeeService.getEmp(empId);
		return Message.success().add("emp", employee);
	}
	
	/**
	 * 保存员工的请求
	 * 1.支持JSR303校验
	 * 2.导入Hibernate-Validator
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Message saveEmp(@Valid Employee employee,BindingResult result) {	
		if(result.hasErrors()) {
			//校验失败，应该返回失败，在模态框中显示校验失败的错误信息
			Map<String,Object> map = new HashMap<String, Object>();
			List<FieldError> errors = result.getFieldErrors();
			for (FieldError fieldError : errors) {
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Message.fail().add("errorFields",map);
		}else {
			employeeService.saveEmp(employee);
			return Message.success();
		}
	}
	
	/**
	 *  查询员工的请求
	 * @param pn
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Message getEmpsWithJson(@RequestParam(value="pn",defaultValue="1")Integer pn) {
		//使用PageHeper插件实现分页查询
		//引入PageHeper分页插件
		//在查询之前只需要调用，传入页码以及每页的大小
		PageHelper.startPage(pn, 5);
		PageHelper.orderBy("emp_id asc");
		//startPage后面紧跟的这个查询就是分页查询
		List<Employee> emps = employeeService.getAll();
		//使用PageInfo包装查询后的结果，只需要将PageInfo交给页面就行了。
		//封装了详细的分页信息，包括有我们查询出来的数据（emps为查询出来的数据，5位当前显示的页码数）
		PageInfo page = new PageInfo(emps,5);
		
		return Message.success().add("pageInfo",page);
	}
	
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue="1")Integer pn,
			Model model) {
		//使用PageHeper插件实现分页查询
		//引入PageHeper分页插件
		//在查询之前只需要调用，传入页码以及每页的大小
		PageHelper.startPage(pn, 5);
		PageHelper.orderBy("emp_id asc");
		//startPage后面紧跟的这个查询就是分页查询
		List<Employee> emps = employeeService.getAll();
		//使用PageInfo包装查询后的结果，只需要将PageInfo交给页面就行了。
		//封装了详细的分页信息，包括有我们查询出来的数据
		PageInfo page = new PageInfo(emps,5);
		model.addAttribute("pageInfo", page);
		
		return "list";
	}
	
}
