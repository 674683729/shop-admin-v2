package com.fh.shop.admin.biz.sort;

import com.fh.shop.admin.mapper.sort.ISortMapper;
import com.fh.shop.admin.po.sort.Sort;
import com.fh.shop.admin.vo.sort.SortVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service("sortService")
public class ISortServiceImpl implements ISortService {
    @Autowired
    private ISortMapper sortMapper;

    //查询分类表集合
    @Override
    public List<SortVo> findSortList() {
        List<Sort> sortList = sortMapper.findSortList();
        //po转vo
        List<SortVo> sortVoList = getSortVoList(sortList);
        return sortVoList;
    }

    //新增分类节点
    @Override
    public void addSort(Sort sort) {
        sortMapper.addSort(sort);
    }

    //修改分类节点
    @Override
    public void updateSort(Sort sort) {
        sortMapper.updateById(sort);
    }

    //删除节点
    @Override
    public void deleteSort(List<Long> ids) {
        sortMapper.deleteBatchIds(ids);
    }

    //po转vo
    private List<SortVo> getSortVoList(List<Sort> sortList) {
        List<SortVo> sortVoList = new ArrayList<>();
        for (Sort sort : sortList) {
            SortVo sortVo = new SortVo();
            sortVo.setId(sort.getId());
            sortVo.setName(sort.getSortName());
            sortVo.setpId(sort.getFatherId());
            sortVoList.add(sortVo);
        }
        return sortVoList;
    }
}
