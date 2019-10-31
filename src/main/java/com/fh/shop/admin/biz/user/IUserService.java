package com.fh.shop.admin.biz.user;

import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.common.ServerResponse;
import com.fh.shop.admin.param.user.UserPasswordParam;
import com.fh.shop.admin.param.user.UserSearchParam;
import com.fh.shop.admin.po.user.User;
import com.fh.shop.admin.vo.user.UserVo;

import java.util.Date;
import java.util.List;

public interface IUserService {

    void addUser(User user);

    void deleteUserById(Long id);

    UserVo findUser(Long id);

    void updateUser(User user);

    DataTableResult findUserPageList(UserSearchParam userSearchParam);

    void batchDelete(List<Integer> ids);

    User findUserByUserName(String userName);

    void updateLogin(Long id, Date date);

    void updateLoginErrorCount(Long id, int i, Date date);

    void updateLockUser(Long id, String email,Date date);

    void updateLock(Long id,Boolean lock);

    List<UserVo> findUserExpord(UserSearchParam userSearchParam);

    void updateLoginCount(Long id, int i);

    void updateResultLoginErrorCount(Long id);

    ServerResponse updatePassword(UserPasswordParam userPasswordParam);

    ServerResponse updateResultPassword(Long id);

    ServerResponse updateFindPassword(String email);

    User findUserByEmail(String email);
}
