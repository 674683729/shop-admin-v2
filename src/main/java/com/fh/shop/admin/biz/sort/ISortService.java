package com.fh.shop.admin.biz.sort;

import com.fh.shop.admin.po.sort.Sort;
import com.fh.shop.admin.vo.sort.SortVo;

import java.util.List;

public interface ISortService {
    List<SortVo> findSortList();

    void addSort(Sort sort);

    void updateSort(Sort sort);

    void deleteSort(List<Long> ids);
}
