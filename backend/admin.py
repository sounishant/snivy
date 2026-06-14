import json
from textual.app import App, ComposeResult
from textual.widgets import Header, Footer, Button, Static
import requests

class SnivyControl(App):
    BINDINGS = [("q", "quit", "Quit")]

    def compose(self) -> ComposeResult:
        yield Header()
        yield Static("snivy-engine: Control Plane", id="title")
        
        # Load switches from the JSON file
        with open("backend/switches.json") as f:
            self.switches = json.load(f)
            for s in self.switches:
                yield Button(s["label"], id=s["id"])
                
        yield Footer()

    def on_button_pressed(self, event: Button.Pressed) -> None:
        # Find the switch definition based on the clicked button ID
        switch = next((s for s in self.switches if s["id"] == event.button.id), None)
        
        if switch:
            payload = {
                "category": "feature_flags",
                "key": switch["key"],
                "value": {"enabled": True, "rollout_percentage": 100}
            }
            try:
                requests.post("http://localhost:8000/admin/update", json=payload)
                self.query_one("#title").update(f"Success: {switch['key']} updated")
            except Exception as e:
                self.query_one("#title").update(f"Error: {str(e)}")

if __name__ == "__main__":
    SnivyControl().run()