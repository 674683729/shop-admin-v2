package com.fh.shop.admin.biz.log;

import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.param.log.LogSearchParam;
import com.fh.shop.admin.po.log.Log;

public interface ILogService {
    void addLog(Log log);

    DataTableResult findLogList(LogSearchParam logSearchParam);
}
