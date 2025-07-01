package AddToCartServlet; 

public class CartItem {
    private String id;
    private String name;
    private double price;
    private int quantity;
    private String image;

    public CartItem(String id, String name, double price, int quantity, String image) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
    }

    // Getters
    public String getId() { return id; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
    public String getImage() { return image; }

    // Setters
    public void setId(String id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setPrice(double price) { this.price = price; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public void setImage(String image) { this.image = image; }

    // Helper method to get subtotal for this item
    public double getSubtotal() {
        return this.price * this.quantity;
    }

    // Helper method to increment quantity
    public void incrementQuantity(int amount) {
        this.quantity += amount;
    }
}