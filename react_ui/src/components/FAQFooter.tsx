import React from 'react'
import { useTranslation } from 'react-i18next'

import { ShadowButtonLink } from './ShadowButtonLink'

export const FAQFooter = () => {
  const { t } = useTranslation()

  return (
    <div className="flex flex-col justify-center py-6 pb-12 sm:py-12">
      <h2 className="text-center font-heading font-semibold text-2xl sm:text-5xl mb-6">
        {t('chapter.faqHeader')}
      </h2>

      <ShadowButtonLink
        className="bg-mfd-cobalt-0 sm:w-auto"
        external={true}
        to="https://masksfordocs.com/faq">
        {t('chapter.faqLink')}
      </ShadowButtonLink>
    </div>
  )
}
