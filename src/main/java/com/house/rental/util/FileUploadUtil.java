package com.house.rental.util;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

public class FileUploadUtil {
    private static final String UPLOAD_DIRECTORY = "uploads";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final List<String> ALLOWED_EXTENSIONS = List.of("jpg", "jpeg", "png", "gif");

    /**
     * 保存多个文件到指定的基础路径下。
     * @param parts 文件的Part列表
     * @param basePath 上传文件的根目录（例如：getServletContext().getRealPath("")）
     * @return 保存成功的文件名列表（包含相对路径，如：uploads/houses/xxx.jpg）
     * @throws IOException 如果保存文件时发生I/O错误
     */
    public static List<String> saveFiles(Collection<Part> parts, String basePath) throws IOException {
        List<String> savedFileNames = new ArrayList<>();
        String uploadPath = basePath + File.separator + UPLOAD_DIRECTORY;
        
        // 创建上传目录
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        for (Part part : parts) {
            String fileName = getFileName(part);
            if (fileName != null && !fileName.isEmpty()) {
                // 验证文件
                if (!isValidFile(part)) {
                    continue;
                }

                // 生成唯一文件名
                String uniqueFileName = generateUniqueFileName(fileName);
                String filePath = uploadPath + File.separator + uniqueFileName;

                // 保存文件
                part.write(filePath);
                savedFileNames.add(UPLOAD_DIRECTORY + File.separator + uniqueFileName); // Return relative path
            }
        }

        return savedFileNames;
    }

    /**
     * 处理来自HttpServletRequest的文件上传，并将文件保存到指定目录。
     * @param request HttpServletRequest对象
     * @param relativeUploadDirectory 相对于Web根目录的上传目录，例如 "uploads/houses"
     * @return 上传成功的文件URL列表（相对路径）
     * @throws IOException 如果保存文件时发生I/O错误
     * @throws ServletException 如果请求无法处理
     */
    public static List<String> uploadFiles(HttpServletRequest request, String relativeUploadDirectory) throws IOException, ServletException {
        List<String> imageUrls = new ArrayList<>();
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + relativeUploadDirectory;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        for (Part part : request.getParts()) {
            String fileName = getFileName(part);
            if (fileName != null && !fileName.isEmpty() && part.getSize() > 0) {
                // 验证文件
                if (!isValidFile(part)) {
                    continue;
                }
                // 生成唯一文件名
                String uniqueFileName = generateUniqueFileName(fileName);
                String filePath = uploadPath + File.separator + uniqueFileName;
                part.write(filePath);
                imageUrls.add(relativeUploadDirectory.replace(File.separator, "/") + "/" + uniqueFileName); // Store path as URL
            }
        }
        return imageUrls;
    }

    private static String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    private static boolean isValidFile(Part part) {
        // 检查文件大小
        if (part.getSize() > MAX_FILE_SIZE) {
            return false;
        }

        // 检查文件扩展名
        String fileName = getFileName(part);
        if (fileName == null || fileName.isEmpty()) {
            return false;
        }
        String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        return ALLOWED_EXTENSIONS.contains(extension);
    }

    private static String generateUniqueFileName(String originalFileName) {
        String extension = "";
        int dotIndex = originalFileName.lastIndexOf(".");
        if (dotIndex > 0) {
            extension = originalFileName.substring(dotIndex);
        }
        return UUID.randomUUID().toString() + extension;
    }
} 