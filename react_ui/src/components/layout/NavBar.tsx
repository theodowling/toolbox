import React, { useCallback, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { NavLink } from 'react-router-dom'

import { DonateButton } from '../DonateButton'
import { M4DLogo } from './M4DLogo'

export const NavBar: React.FC = () => {
  const { t } = useTranslation()
  const [menuOpen, setMenuOpen] = useState(false)

  const toggleMenu = useCallback(() => {
    setMenuOpen((open) => !open)
  }, [])

  const hideMenu = useCallback(() => {
    setMenuOpen(false)
  }, [])

  return (
    <header className="sticky top-0 z-50">
      <nav className="flex flex-row items-center justify-between flex-wrap flex-shrink-0 w-full max-w-7xl mx-auto rounded-b bg-black font-heading text-gray-100 p-2 lg:py-4 lg:px-2">
        <button
          onClick={toggleMenu}
          data-cy="toggle-menu"
          className="lg:hidden flex items-center px-3 py-2 focus:outline-none">
          <svg
            width="18"
            height="17"
            viewBox="0 0 18 17"
            fill="none"
            xmlns="http://www.w3.org/2000/svg">
            <title>{t('navBar.toggleMenu')}</title>

            <path
              d="M1.8 3.27407H16.2C17.19 3.27407 18 2.53741 18 1.63704C18 0.736667 17.19 0 16.2 0H1.8C0.81 0 0 0.736667 0 1.63704C0 2.53741 0.81 3.27407 1.8 3.27407ZM16.2 13.7259H1.8C0.81 13.7259 0 14.4626 0 15.363C0 16.2633 0.81 17 1.8 17H16.2C17.19 17 18 16.2633 18 15.363C18 14.4626 17.19 13.7259 16.2 13.7259ZM16.2 6.86296H1.8C0.81 6.86296 0 7.59963 0 8.5C0 9.40037 0.81 10.137 1.8 10.137H16.2C17.19 10.137 18 9.40037 18 8.5C18 7.59963 17.19 6.86296 16.2 6.86296Z"
              fill="white"
            />
          </svg>
        </button>

        <a
          className="flex items-center flex-shrink-0 lg:ml-4 lg:mr-9 flex-grow lg:flex-grow-0"
          href="https://masksfordocs.com">
          <M4DLogo />
        </a>

        <DonateButton
          onClick={hideMenu}
          className="sm:hidden lg:mr-2 self-end lg:mt-0"
        />

        <div
          className={`w-full ${
            menuOpen ? 'block' : 'hidden'
          } ml-3 lg:ml-8 flex-grow lg:flex lg:items-center lg:w-auto flex-shrink-0`}>
          <div className="text-sm pb-4 lg:pb-0 lg:flex-grow flex-shrink-0">
            <HeaderNavLink
              onClick={hideMenu}
              to="https://masksfordocs.com/about-us">
              {t('navBar.aboutLink')}
            </HeaderNavLink>

            <HeaderNavLink
              onClick={hideMenu}
              to="https://masksfordocs.com/news">
              {t('navBar.newsLink')}
            </HeaderNavLink>

            <HeaderNavLink
              onClick={hideMenu}
              to="https://masksfordocs.com/get-involved">
              {t('navBar.getInvolvedLink')}
            </HeaderNavLink>

            <HeaderNavLink
              onClick={hideMenu}
              to="https://masksfordocs.com/get-supplies">
              {t('navBar.suppliesLink')}
            </HeaderNavLink>

            <HeaderNavLink onClick={hideMenu} to="/chapters">
              {t('navBar.chaptersLink')}
            </HeaderNavLink>

            <HeaderNavLink
              onClick={hideMenu}
              to="https://masksfordocs.com/resources">
              {t('navBar.resourcesLink')}
            </HeaderNavLink>

            <HeaderNavLink onClick={hideMenu} to="https://masksfordocs.com/faq">
              {t('navBar.faqLink')}
            </HeaderNavLink>
          </div>
        </div>

        <DonateButton
          onClick={hideMenu}
          className="hidden sm:block lg:mr-2 self-end lg:mt-0"
        />
      </nav>
    </header>
  )
}

const HeaderNavLink: React.FC<{
  onClick?: () => void
  to: string
}> = ({ to, children, onClick, ...rest }) => {
  const className =
    'block font-medium mt-4 lg:inline-block lg:mt-0 active:text-pink-400 cursor-pointer mr-12 hover:text-mfd-pink-1'
  if (to.startsWith('http')) {
    return (
      <a href={to} className={className} onClick={onClick} {...rest}>
        {children}
      </a>
    )
  }

  return (
    <NavLink
      onClick={onClick}
      to={to}
      activeClassName="text-mfd-pink-1"
      className={className}
      {...rest}>
      {children}
    </NavLink>
  )
}
