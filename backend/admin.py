from textual.app import App, ComposeResult
from textual.widgets import Header, Footer, Button, Static
import requests

class SnivyControl(App):
    BINDINGS = [("q", "quit", "Quit")]

    def compose(self) -> ComposeResult:
        yield Header()
        yield Static("snivy-engine: Control Plane", id="title")
        yield Button("Toggle New Checkout Flow", id="checkout_btn", variant="primary")
        yield Footer()

    def on_button_pressed(self, event: Button.Pressed) -> None:
        if event.button.id == "checkout_btn":
            # We now send the full dictionary as 'value'
            # The backend will automatically handle the update
            payload = {
                "category": "feature_flags",
                "key": "new_checkout_flow",
                "value": {
                    "enabled": True, 
                    "rollout_percentage": 100, 
                    "beta_users": ""
                }
            }
            
            try:
                requests.post("http://localhost:8000/admin/update", json=payload)
                self.query_one("#title").update("Success: new_checkout_flow updated")
            except Exception as e:
                self.query_one("#title").update(f"Error: {str(e)}")

if __name__ == "__main__":
    SnivyControl().run()