package cn.kmust.crud.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * 通用的返回的类
 * @author yz
 *
 */
public class Message {

	//状态码  100-成功  200-失败
	private int code;
	//提示信息
	private String msg;
	
	//用户要返回给浏览器的数据
	private Map<String,Object> extend = new HashMap<String,Object>();

	//成功方法
	public static Message success() {
		Message result = new Message();
		result.setCode(100);
		result.setMsg("操作成功！");
		return result;
	}
	
	//失败方法
	public static Message fail() {
		Message result = new Message();
		result.setCode(200);
		result.setMsg("操作失败！");
		return result;
	}
	
	
	//带入数据
	public Message add(String key,Object value) {
		this.getExtend().put(key, value);
		return this;
	}
	
	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public Map<String, Object> getExtend() {
		return extend;
	}

	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}
	
}
