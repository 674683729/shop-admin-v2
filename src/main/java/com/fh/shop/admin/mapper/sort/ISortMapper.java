package com.fh.shop.admin.mapper.sort;

import com.fh.shop.admin.po.sort.Sort;

import java.util.List;

public interface ISortMapper {
    List<Sort> findSortList();

    void addSort(Sort sort);

    void deleteBatchIds(List<Long> ids);

    void updateById(Sort sort);
}
