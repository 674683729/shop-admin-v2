package com.fh.shop.admin.util;

import redis.clients.jedis.Jedis;

public class RedisUtil {

    public static void set(String key, String value) {
        Jedis resource = null;
        try {
            resource = RedisPool.getResource();
            resource.set(key, value);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        } finally {
            if (resource != null) {
                resource.close();
            }
        }
    }

    public static String get(String key) {
        Jedis resource = null;
        String result = null;
        try {
            resource = RedisPool.getResource();
            result = resource.get(key);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        } finally {
            if (resource != null) {
                resource.close();
            }
        }
        return result;
    }

    public static void del(String key) {
        Jedis resource = null;
        try {
            resource = RedisPool.getResource();
            resource.del(key);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        } finally {
            if (resource != null) {
                resource.close();
            }
        }
    }

    public static void expire(String key, int second) {
        Jedis resource = null;
        try {
            resource = RedisPool.getResource();
            resource.expire(key, second);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        } finally {
            if (resource != null) {
                resource.close();
            }
        }

    }

    public static void setEx(String key, int second,String value) {
        Jedis resource = null;
        try {
            resource = RedisPool.getResource();
            resource.setex(key, second, value);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e.getMessage());
        } finally {
            if (resource != null) {
                resource.close();
            }
        }

    }

    
}
