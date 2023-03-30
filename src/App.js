import logo from "./logo.svg";
import "./App.css";

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <p>port: {process.env.REACT_APP_SSH_PORT}</p>
      </header>
    </div>
  );
}

export default App;
