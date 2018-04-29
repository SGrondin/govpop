import React from "react";
import { Switch, Route, Link } from 'react-router-dom'
import { ajax, getSSID } from "../helpers/ajax"
import ProfilePage from "./ProfilePage"
import BrowseQuestions from "./BrowseQuestions"

export default class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      ssid: getSSID(),
      loggedIn: false,
      error: null,
      profile: null
    }
  }

  async logIn() {
    try {
      const login = await ajax('post', '/users/session', null, {
        email: this.refs.email.value,
        password: this.refs.password.value
      })
      this.setState({ ssid: login.body.ssid, loggedIn: true, error: null })
    } catch (e) {
      this.setState({ error: e.message, ssid: null })
    }
  }

  async logOut() {
    try {
      await ajax('delete', '/users/session')
      this.setState({ ssid: null, loggedIn: false })
    } catch (e) {
      this.setState({ error: e.message })
    }
  }

  async checkSession() {
    try {
      await ajax('get', '/users/session')
      this.setState({ loggedIn: true, error: null })
    } catch (e) {
      this.setState({ ssid: null })
    }
  }

  render() {
    if (this.state.ssid == null) {
      return (
        <div>
          {this.state && (<div>{this.state.error}</div>)}
          <input type="text" ref="email" />
          <input type="password" ref="password" />
          <button onClick={this.logIn.bind(this)}>Login</button>
        </div>
      );
    } else if (this.state.loggedIn !== true) {
      this.checkSession()
      return (
        <div>Connecting...</div>
      )
    } else {
      return (
        <div>
          Welcome!
          <button onClick={this.logOut.bind(this)}>Logout</button>

          <Switch>
            <Route exact path="/profile" component={ProfilePage} />
            <Route render={() => (
              <div>
                <div><Link to="/profile">Profile</Link></div>

                <BrowseQuestions />

              </div>
            )} />
          </Switch>

        </div>
      )
    }
  }
}
