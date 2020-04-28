package cn.kmust.crud.test;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import cn.kmust.crud.bean.Department;
import cn.kmust.crud.bean.DepartmentExample;
import cn.kmust.crud.bean.DepartmentExample.Criteria;
import cn.kmust.crud.bean.Employee;
import cn.kmust.crud.dao.DepartmentMapper;
import cn.kmust.crud.dao.EmployeeMapper;

/**
 *     测试dao层的工作
 * @author yz
 * 推荐spring的项目就可以使用Spring的单元测试，可以自动注入我们需要的组件
 * 1.导入SpringTest模块
 * 2.@ContextConfiguration指定Spring配置文件的位置
 */
@RunWith(value=SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations= {"classpath:applicationContext.xml"})
public class MapperTest {

	@Autowired
	DepartmentMapper departmentMapper;
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Autowired
	SqlSession sqlSession;
	
	@Test
	public void testCRUD() {
	
		System.out.println(departmentMapper);
		
		//1.插入几个部门
//		departmentMapper.insertSelective(new Department(null,"开发部"));
//		departmentMapper.insertSelective(new Department(null,"技术部"));
		
		//测试查询 
//		DepartmentExample departmentExample = new DepartmentExample();
//		Criteria createCriteria = departmentExample.createCriteria();
//		createCriteria.andDeptNameLike("%开发%");
//		List<Department> selectByExample = departmentMapper.selectByExample(departmentExample);
//		for (Department department : selectByExample) {
//			System.out.println(department);
//		}
		
		//插入几个员工
		employeeMapper.insertSelective(new Employee(null,"Jerry","M","Jerry@qq.com",1));
		
		//批量插入
		EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
		for(int i=0;i < 1000;i++) {
			String uid = UUID.randomUUID().toString().substring(0, 5)+i;
			mapper.insertSelective(new Employee(null,uid,"M",uid+"@qq.com",1 ));
		}
		System.out.println("批量完成");
	}
	
}
