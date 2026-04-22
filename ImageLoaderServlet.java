import java.io.*;
import java.nio.file.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/ImageLoader")
public class ImageLoaderServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String fileName = request.getParameter("img");
        
        // If no image, show a default one (ensure you have a default.png in your C:/library_images/ folder)
        if (fileName == null || fileName.isEmpty()) {
            fileName = "default.png";
        }
        
        File file = new File("C:/library_images/" + fileName);
        
        // Check if file exists, if not, serve default
        if(!file.exists()) {
             // You can optionally redirect to a web-based default image here if local default is missing
             return;
        }

        // Send the image to the browser
        response.setContentType(getServletContext().getMimeType(fileName));
        response.setContentLength((int) file.length());
        
        FileInputStream in = new FileInputStream(file);
        OutputStream out = response.getOutputStream();
        
        byte[] buf = new byte[1024];
        int count = 0;
        while ((count = in.read(buf)) >= 0) {
            out.write(buf, 0, count);
        }
        out.close();
        in.close();
    }
}