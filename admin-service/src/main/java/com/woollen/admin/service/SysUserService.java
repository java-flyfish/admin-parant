package com.woollen.admin.service;

import com.woollen.admin.dao.entry.SysUser;
import org.springframework.data.domain.Example;

import java.util.List;

/**
 * @Info:
 * @ClassName: ManagerUserService
 * @Author: weiyang
 * @Data: 2019/10/12 3:20 PM
 * @Version: V1.0
 **/
public interface SysUserService {
    SysUser selectNamaAndPassword(String name,String password);

    List<SysUser> selectByCondition(String search, Integer pageNum, Integer pageSize);

    Integer deleteById(Integer id);
}
