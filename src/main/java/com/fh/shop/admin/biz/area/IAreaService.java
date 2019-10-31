package com.fh.shop.admin.biz.area;

import com.fh.shop.admin.po.area.Area;

import java.util.List;
import java.util.Map;

public interface IAreaService {
    List<Map> findAreaList();

    void addCity(Area area);

    void deleteArea(List<Long> ids);

    void updateArea(Area area);
}
