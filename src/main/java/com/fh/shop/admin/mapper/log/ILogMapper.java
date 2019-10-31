package com.fh.shop.admin.mapper.log;

import com.fh.shop.admin.param.log.LogSearchParam;
import com.fh.shop.admin.po.log.Log;

import java.util.List;

public interface ILogMapper {

    void addLog(Log log);

    Long findLogCount(LogSearchParam logSearchParam);

    List<Log> findLogPageList(LogSearchParam logSearchParam);
}
