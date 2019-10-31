package com.fh.shop.admin.biz.log;

import com.fh.shop.admin.common.DataTableResult;
import com.fh.shop.admin.mapper.log.ILogMapper;
import com.fh.shop.admin.param.log.LogSearchParam;
import com.fh.shop.admin.po.log.Log;
import com.fh.shop.admin.po.product.Product;
import com.fh.shop.admin.util.DateUtil;
import com.fh.shop.admin.vo.log.LogVo;
import com.fh.shop.admin.vo.product.ProductVo;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service("logService")
public class ILogServiceImpl implements ILogService {
    @Autowired
    private ILogMapper logMapper;

    //新增日志信息
    @Override
    public void addLog(Log log) {
        logMapper.addLog(log);
    }

    //日志分页查询
    @Override
    public DataTableResult findLogList(LogSearchParam logSearchParam) {
        //查询商品总条数
        Long totalCount=logMapper.findLogCount(logSearchParam);
        //查询分页数据
        List<Log> logList = logMapper.findLogPageList(logSearchParam);
        //po转vo
        List<LogVo> logVoList = buildLogVoList(logList);
        DataTableResult dataTableResult=new DataTableResult(logSearchParam.getDraw(),totalCount,totalCount,logVoList);
        return dataTableResult;
    }

    private List<LogVo> buildLogVoList(List<Log> logList) {
        List<LogVo> logVoList = new ArrayList<LogVo>();
        for (Log logInfo : logList) {
            LogVo logVo = new LogVo();
            logVo.setId(logInfo.getId());
            logVo.setUserName(logInfo.getUserName());
            logVo.setRealName(logInfo.getRealName());
            logVo.setCurrTime(DateUtil.date2str(logInfo.getCurrTime(),DateUtil.FUFF_YEAR));
            logVo.setInfo(logInfo.getInfo());
            logVo.setStatus(logInfo.getStatus());
            logVo.setErrorMsg(logInfo.getErrorMsg());
            if (StringUtils.isNotEmpty(logInfo.getDetail())){
                logVo.setDetail(logInfo.getDetail().substring(1));
            }
            logVo.setContext(logInfo.getContext());
            logVoList.add(logVo);
        }
        return logVoList;
    }


}
