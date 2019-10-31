package com.fh.shop.admin.biz.area;

import com.fh.shop.admin.mapper.area.IAreaMapper;
import com.fh.shop.admin.po.area.Area;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("areaService")
public class IAreaServiceImpl implements IAreaService {
    @Autowired
    private IAreaMapper areaMapper;


    @Override
    public List<Map> findAreaList() {
        List<Area> areaList = areaMapper.findAreaList();
        List<Map> areaTreeList=new ArrayList<Map>();
        for (Area area : areaList) {
            Map map = new HashMap<>();
            map.put("id", area.getId());
            map.put("pId", area.getPid());
            map.put("name", area.getCityName());
            map.put("type", area.getType());
            areaTreeList.add(map);
        }
        return areaTreeList;
    }

    @Override
    public void addCity(Area area) {
        areaMapper.addCity(area);
    }

    @Override
    public void deleteArea(List<Long> ids) {
        areaMapper.deleteArea(ids);
    }

    @Override
    public void updateArea(Area area) {
        areaMapper.updateArea(area);
    }
}
