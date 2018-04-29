import React from "react";
import { Link } from 'react-router-dom'
import { ajax } from "../helpers/ajax"

export default class BrowseQuestions extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      questions: null
    }
  }

  componentWillMount() {
    this.getQuestions()
  }

  async getQuestions() {
    try {
      const questions = await ajax('get', '/questions')
      this.setState({ questions: questions.body.questions })
    } catch (e) {
      console.error(e)
    }
  }

  render() {
    return (
      <div>
        <div><Link to="/">Main page</Link></div>

        {this.state.questions != null && (
          <ul>{
            Object.keys(this.state.questions).map((k, i) => {
              return (<li key={i}>{JSON.stringify(this.state.questions[k])}</li>)
            })
          }</ul>
        )}

      </div>
    )
  }
}
