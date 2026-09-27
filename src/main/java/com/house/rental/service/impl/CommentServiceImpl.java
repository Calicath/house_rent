package com.house.rental.service.impl;

import java.util.List;

import com.house.rental.bean.Comment;
import com.house.rental.dao.CommentDAO;
import com.house.rental.dao.impl.CommentDAOImpl;
import com.house.rental.service.CommentService;

public class CommentServiceImpl implements CommentService {
    private CommentDAO commentDAO = new CommentDAOImpl();

    @Override
    public boolean addComment(Comment comment) {
        try {
            commentDAO.addComment(comment);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateComment(Comment comment) {
        try {
            commentDAO.updateComment(comment);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteComment(int commentId) {
        try {
            commentDAO.deleteComment(commentId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Comment getCommentById(int commentId) {
        try {
            return commentDAO.getCommentById(commentId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Comment> getCommentsByPostId(int postId) {
        try {
            return commentDAO.getCommentsByPostId(postId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Comment> getCommentsWithDetailsByPostId(int postId) {
        try {
            return commentDAO.getCommentsWithDetailsByPostId(postId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Comment> getCommentsByUserId(int userId) {
        try {
            return commentDAO.getCommentsByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Comment> getRepliesByParentId(int parentId) {
        try {
            return commentDAO.getRepliesByParentId(parentId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Comment> getRepliesWithDetailsByParentId(int parentId) {
        try {
            return commentDAO.getRepliesWithDetailsByParentId(parentId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean incrementLikeCount(int commentId) {
        try {
            commentDAO.incrementLikeCount(commentId);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getCommentCount() {
        try {
            return commentDAO.getCommentCount();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int getCommentCountByPostId(int postId) {
        try {
            return commentDAO.getCommentCountByPostId(postId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int getReplyCountByParentId(int parentId) {
        try {
            return commentDAO.getReplyCountByParentId(parentId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public Comment getCommentWithDetails(int commentId) {
        try {
            return commentDAO.getCommentWithDetails(commentId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
} 