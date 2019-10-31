package com.fh.shop.admin.mapper.area;

import com.fh.shop.admin.po.area.Area;

import java.util.List;

public interface IAreaMapper {

    List<Area> findAreaList();

    void addCity(Area area);

    void deleteArea(List<Long> ids);

    void updateArea(Area area);
}
