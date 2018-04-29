import React from "react";
import { Link } from 'react-router-dom'
import { ajax } from "../helpers/ajax"

export default class ProfilePage extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      profile: null
    }
  }

  componentWillMount() {
    this.getProfile()
  }

  async getProfile() {
    try {
      const profile = await ajax('get', '/users/profile')
      this.setState({ profile: profile.body })
    } catch (e) {
      console.error(e)
    }
  }

  render() {
    return (
      <div>
        <div><Link to="/">Main page</Link></div>

        {this.state.profile != null && (
          <ul>{
            Object.keys(this.state.profile).map((k, i) => {
              return (<li key={i}>{k}: {this.state.profile[k]}</li>)
            })
          }</ul>
        )}

      </div>
    )
  }
}
