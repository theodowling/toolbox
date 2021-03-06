import { v4 } from 'uuid'

describe('Sign up', () => {
  it('directly to sign in page', () => {
    cy.visit('/sign-in')
    cy.get('[data-test=sign-in-create-account-link]').click()
  })

  it('fill in the form', () => {
    const emailInput = cy.get(
      ':nth-child(1) > [data-test=sign-up-non-phone-number-input]'
    )
    emailInput.type(`alex-${v4()}@example.com`)
    const passwordInput = cy.get(
      ':nth-child(2) > [data-test=sign-up-non-phone-number-input]'
    )
    passwordInput.type('FooB@r42!')
    const button = cy.get('[data-test=sign-up-create-account-button]')
    button.click()
  })

  it('see Confirm Sign Up page', () => {
    cy.get('[data-test=confirm-sign-up-confirm-button]').should('exist')
  })
})
