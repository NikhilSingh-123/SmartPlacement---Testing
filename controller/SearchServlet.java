package com.smartplacement.controller;

import com.smartplacement.dao.JobDriveDAO;
import com.smartplacement.model.JobDrive;
import com.smartplacement.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("userObj");

        if (student == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String keyword    = request.getParameter("query");
        String branch     = request.getParameter("branch");
        String minPackage = request.getParameter("minPackage");

        if (keyword == null) keyword = "";
        if (branch == null)  branch  = "";

        JobDriveDAO dao = new JobDriveDAO();
        List<JobDrive> drives;

        if (keyword.isEmpty() && branch.isEmpty() && (minPackage == null || minPackage.isEmpty())) {
            drives = dao.getDrivesForStudent(student.getId());
        } else {
            drives = dao.searchDrives(student.getId(), keyword, branch, minPackage);
        }

        request.setAttribute("drives", drives);
        request.setAttribute("searchQuery", keyword);
        request.setAttribute("selectedBranch", branch);
        request.getRequestDispatcher("/student/jobs.jsp").forward(request, response);
    }
}
