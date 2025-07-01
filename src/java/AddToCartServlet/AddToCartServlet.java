package AddToCartServlet; // << REPLACE with your actual package name

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String productId = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String productPriceStr = request.getParameter("productPrice");
        String productImage = request.getParameter("productImage");
        int quantityToAdd = 1; // Default quantity to add

        HttpSession session = request.getSession();
        
        @SuppressWarnings("unchecked") // Suppress warning for cast
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>(); // Initialize cart if it doesn't exist
        }

        boolean itemExistsInCart = false;
        if (productId != null && !productId.trim().isEmpty() && 
            productName != null && !productName.trim().isEmpty() &&
            productPriceStr != null && !productPriceStr.trim().isEmpty()) {
            try {
                double productPrice = Double.parseDouble(productPriceStr);

                // Check if item already exists in cart
                for (CartItem item : cart) {
                    if (item.getId().equals(productId)) {
                        item.incrementQuantity(quantityToAdd); // Increment quantity
                        itemExistsInCart = true;
                        break;
                    }
                }

                // If item does not exist, add as new item
                if (!itemExistsInCart) {
                    CartItem newItem = new CartItem(productId, productName, productPrice, quantityToAdd, productImage);
                    cart.add(newItem);
                }
                session.setAttribute("cart", cart); // Update cart in session
                session.setAttribute("cartMessage", "Product '" + productName + "' added to cart!"); // Success message
            } catch (NumberFormatException e) {
                e.printStackTrace(); // Log error
                session.setAttribute("cartError", "Invalid product price."); // Error message
            }
        } else {
             session.setAttribute("cartError", "Incomplete product details to add to cart."); // Error message
        }
        
        // Redirect to the cart page
        response.sendRedirect("cart.jsp");
    }
}