package com.blooddonationmanagementsystem.controller;

package com.blooddonationmanagementsystem.controller;
 
import com.blooddonationmanagementsystem.model.Donation;
import com.blooddonationmanagementsystem.service.DonationService;
import com.blooddonationmanagementsystem.service.DonorService;
 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
 
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;