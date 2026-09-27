package com.house.rental.service.impl;

import java.util.List;

import com.house.rental.bean.ForumPost;
import com.house.rental.dao.ForumPostDAO;
import com.house.rental.dao.impl.ForumPostDAOImpl;
import com.house.rental.service.ForumPostService;

public class ForumPostServiceImpl implements ForumPostService {
    private ForumPostDAO forumPostDAO = new ForumPostDAOImpl();

    @Override
    public boolean addForumPost(ForumPost post) {
        try {
            forumPostDAO.addForumPost(post);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateForumPost(ForumPost post) {
        try {
            forumPostDAO.updateForumPost(post);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteForumPost(int postId) {
        try {
            forumPostDAO.deleteForumPost(postId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public ForumPost getForumPostById(int postId) {
        try {
            return forumPostDAO.getForumPostById(postId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public ForumPost getForumPostWithDetails(int postId) {
        try {
            return forumPostDAO.getForumPostWithDetails(postId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ForumPost> getAllForumPosts(int page, int pageSize) {
        try {
            int offset = (page - 1) * pageSize;
            return forumPostDAO.getAllForumPosts(offset, pageSize);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ForumPost> getAllForumPostsWithDetails(int page, int pageSize) {
        try {
            int offset = (page - 1) * pageSize;
            return forumPostDAO.getForumPostsWithDetails(offset, pageSize);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ForumPost> getForumPostsByCategory(String category, int page, int pageSize) {
        try {
            int offset = (page - 1) * pageSize;
            return forumPostDAO.getForumPostsByCategory(category, offset, pageSize);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ForumPost> getForumPostsByUserId(int userId) {
        try {
            return forumPostDAO.getForumPostsByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ForumPost> searchForumPosts(String keyword, int page, int pageSize) {
        try {
            int offset = (page - 1) * pageSize;
            return forumPostDAO.searchForumPosts(keyword, offset, pageSize);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ForumPost> getPinnedForumPosts() {
        try {
            return forumPostDAO.getPinnedForumPosts();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean incrementViewCount(int postId) {
        try {
            forumPostDAO.incrementViewCount(postId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean incrementLikeCount(int postId) {
        try {
            forumPostDAO.incrementLikeCount(postId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getForumPostCount() {
        try {
            return forumPostDAO.getForumPostCount();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int getForumPostCountByCategory(String category) {
        try {
            return forumPostDAO.getForumPostCountByCategory(category);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int getSearchForumPostCount(String keyword) {
        try {
            return forumPostDAO.getSearchForumPostCount(keyword);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int getTotalPages(int totalCount, int pageSize) {
        if (pageSize <= 0) {
            return 0;
        }
        return (int) Math.ceil((double) totalCount / pageSize);
    }
} 