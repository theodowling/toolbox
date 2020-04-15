import React from 'react'
import { useTranslation } from 'react-i18next'

import { classnames } from '../classnames'

const LinkList: React.FC<{
  title: string
  links: { title: string; href: string }[]
  children?: React.ReactChild
}> = ({ title, links, children }) => (
  <div className="flex-1 mb-7 md:mb-0 pr-5 md:pl-5 md:pr-0 text-right md:text-left">
    <div className="text-gray-200 mb-2 md:mb-7 text-sm text-white font-heading font-semibold uppercase">
      {title}
    </div>
    {links.map(({ title, href }) => (
      <div key={title} className="text-xs font-mono mb-3">
        <a href={href}>{title}</a>
      </div>
    ))}
    {children}
  </div>
)

const Copyright: React.FC<{ className?: string }> = ({ className }) => (
  <div
    className={classnames(
      'flex items-center mr-3 font-mono text-xs',
      className
    )}>
    &copy; 2020 Masks For Docs Foundation
  </div>
)

export const Footer: React.FC = () => {
  const { t } = useTranslation()

  return (
    <footer className="pb-14 pl-3 pl-2 md:px-8 md:px-14 bg-black text-gray-100">
      <div className="mx-auto max-w-7xl overflow-hidden">
        <div className="-mt-5">
          <FooterIcon />
        </div>
        <div className="pt-10 md:pt-20">
          <div className="flex flex-row-reverse md:flex-col justify-evenly md:justify-start">
            <div className="flex-1 md:mt-10 md:mt-0 flex">
              <div className="hidden md:block flex-1 mr-3">
                <div className="whitespace-no-wrap text-gray-200 mb-3 text-3xl text-white font-heading whitespace-pre-line">
                  {t('footer.cta')}
                </div>
              </div>
              <div className="flex-1 flex-col md:flex-row space-around flex">
                <LinkList
                  title={t('footer.about.title')}
                  links={[
                    { title: t('footer.about.mission'), href: '/mission' },
                    { title: t('footer.about.whoWeAre'), href: '/whoweare' },
                    {
                      title: t('footer.about.successStories'),
                      href: '/success-stories',
                    },
                  ]}
                />

                <LinkList
                  title={t('footer.resources.title')}
                  links={[
                    {
                      title: t('footer.resources.covidUpdates'),
                      href: '/covid19-updates',
                    },
                    {
                      title: t('footer.resources.fieldGuides'),
                      href: '/field-guides',
                    },
                    {
                      title: t('footer.resources.localChapters'),
                      href: '/local-chapters',
                    },
                    {
                      title: t('footer.resources.localLeadLogin'),
                      href: '/login',
                    },
                  ]}
                />

                <LinkList
                  title={t('footer.more.title')}
                  links={[
                    {
                      title: t('footer.more.termsOfUse'),
                      href: '/tos',
                    },
                    {
                      title: t('footer.more.privacyPolicy'),
                      href: '/privacy',
                    },
                    {
                      title: t('footer.more.codeOfConduct'),
                      href: '/code-of-conduct',
                    },
                    {
                      title: t('footer.more.contactUs'),
                      href: '/contact',
                    },
                  ]}>
                  <div className="text-gray-200 mt-10 text-lg">
                    <a
                      href="/donate"
                      className="bg-mfd-pink-1 inline-block text-sm px-4 py-2 leading-none rounded hover:border-transparent hover:text-pink-700 hover:bg-white mt-4 md:mt-0">
                      {t('footer.donateLink')}
                    </a>
                  </div>
                </LinkList>
              </div>
            </div>
            <div className="md:mt-20 text-xs flex flex-col md:flex-row">
              <Copyright className="hidden md:block" />

              <div className="flex flex-col md:flex-row justify-start md:justify-end flex-1 pr-3 md:pr-14">
                <SocialIcon href="https://www.facebook.com/MasksForDocs/">
                  <svg
                    width="30"
                    height="30"
                    viewBox="0 0 13 30"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg">
                    <title>facebook-social</title>
                    <path
                      d="M3.48014 29.3124H8.85147V14.5319H12.6008L12.9996 9.57586H8.85147C8.85147 9.57586 8.85147 7.73379 8.85147 6.75427C8.85147 5.5847 9.0642 5.13149 10.0879 5.13149C10.9123 5.13149 12.9996 5.13149 12.9996 5.13149V0C12.9996 0 9.9417 0 9.27693 0C5.28831 0 3.48014 1.92979 3.48014 5.64318C3.48014 8.87412 3.48014 9.59048 3.48014 9.59048H0.68811V14.605H3.48014V29.3124Z"
                      fill="#FFE5D2"
                    />
                  </svg>
                </SocialIcon>

                <SocialIcon href="https://twitter.com/MasksForDocs">
                  <svg
                    width="30"
                    height="30"
                    viewBox="0 0 33 26"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg">
                    <title>twitter-social</title>
                    <path
                      d="M33 3.1C31.8 3.6 30.6 4 29.2 4.1C30.6 3.3 31.6 2 32.1 0.5C30.8 1.3 29.4 1.8 27.9 2.1C26.7 0.8 25 0 23.2 0C19.6 0 16.6 2.9 16.6 6.6C16.6 7.1 16.7 7.6 16.8 8.1C11.3 7.8 6.50002 5.2 3.20002 1.2C2.60002 2.2 2.30002 3.3 2.30002 4.5C2.30002 6.8 3.50002 8.8 5.20002 10C4.10002 10 3.10002 9.7 2.20002 9.2V9.3C2.20002 12.5 4.50002 15.1 7.50002 15.7C6.90002 15.8 6.40002 15.9 5.80002 15.9C5.40002 15.9 5.00002 15.9 4.60002 15.8C5.40002 18.4 7.90002 20.3 10.7 20.4C8.50002 22.2 5.60002 23.2 2.50002 23.2C2.00002 23.2 1.40002 23.2 0.900024 23.1C3.90002 24.9 7.40003 26 11.1 26C23.2 26 29.8 16 29.8 7.3C29.8 7 29.8 6.7 29.8 6.5C31 5.5 32.1 4.4 33 3.1Z"
                      fill="#FFE5D2"
                    />
                  </svg>
                </SocialIcon>

                <SocialIcon href="https://www.instagram.com/masksfordocs/">
                  <svg
                    width="30"
                    height="30"
                    viewBox="0 0 30 30"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg">
                    <title>instagram-social</title>
                    <path
                      d="M14.9996 2.7C18.9996 2.7 19.4786 2.715 21.0606 2.787C22.7192 2.73048 24.3353 3.3178 25.5706 4.426C26.6788 5.6613 27.2662 7.27743 27.2096 8.936C27.2816 10.521 27.2996 11 27.2996 15C27.2996 19 27.2846 19.479 27.2126 21.061C27.2692 22.7196 26.6818 24.3357 25.5736 25.571C24.3384 26.6793 22.7222 27.2666 21.0636 27.21C19.4816 27.282 19.0076 27.297 15.0026 27.297C10.9976 27.297 10.5236 27.282 8.94163 27.21C7.28306 27.2665 5.66693 26.6792 4.43163 25.571C3.32334 24.3358 2.73601 22.7196 2.79263 21.061C2.71763 19.479 2.69963 19.005 2.69963 15C2.69963 10.995 2.71463 10.521 2.78663 8.939C2.73011 7.28043 3.31744 5.6643 4.42563 4.429C5.66169 3.32007 7.27904 2.73269 8.93863 2.79C10.5206 2.718 10.9996 2.7 14.9996 2.7ZM14.9996 0C10.9266 0 10.4156 0.017 8.81463 0.09C6.47878 0.0481083 4.21866 0.918791 2.51463 2.517C0.916151 4.22086 0.0454239 6.48109 0.0876338 8.817C0.0166338 10.416 -0.000366211 10.927 -0.000366211 15C-0.000366211 19.073 0.0166338 19.584 0.0896338 21.185C0.0477421 23.5209 0.918424 25.781 2.51663 27.485C4.22049 29.0835 6.48072 29.9542 8.81663 29.912C10.4166 29.985 10.9286 30.002 15.0016 30.002C19.0746 30.002 19.5856 29.985 21.1866 29.912C23.5225 29.9539 25.7826 29.0832 27.4866 27.485C29.0851 25.7811 29.9558 23.5209 29.9136 21.185C29.9866 19.585 30.0036 19.073 30.0036 15C30.0036 10.927 29.9866 10.416 29.9136 8.815C29.9555 6.47914 29.0848 4.21903 27.4866 2.515C25.7828 0.916517 23.5225 0.0457901 21.1866 0.0880001C19.5836 0.0170001 19.0726 0 14.9996 0Z"
                      fill="#FFE5D2"
                    />
                    <path
                      d="M14.9996 7.2998C13.4767 7.2998 11.988 7.7514 10.7217 8.59749C9.45547 9.44358 8.46855 10.6462 7.88576 12.0531C7.30297 13.4601 7.15048 15.0084 7.44759 16.502C7.74469 17.9957 8.47804 19.3677 9.5549 20.4445C10.6318 21.5214 12.0038 22.2548 13.4974 22.5519C14.991 22.849 16.5392 22.6965 17.9462 22.1137C19.3532 21.5309 20.5558 20.544 21.4019 19.2777C22.2479 18.0115 22.6995 16.5227 22.6995 14.9998C22.6995 12.9576 21.8883 10.9991 20.4443 9.55509C19.0002 8.11105 17.0417 7.2998 14.9996 7.2998ZM14.9996 19.9998C14.0107 19.9998 13.044 19.7066 12.2217 19.1572C11.3995 18.6078 10.7587 17.8269 10.3802 16.9132C10.0018 15.9996 9.90276 14.9943 10.0957 14.0244C10.2886 13.0545 10.7648 12.1635 11.4641 11.4643C12.1633 10.765 13.0542 10.2888 14.0241 10.0959C14.994 9.90296 15.9994 10.002 16.913 10.3804C17.8266 10.7588 18.6075 11.3997 19.1569 12.222C19.7063 13.0442 19.9995 14.0109 19.9995 14.9998C19.9995 16.3259 19.4728 17.5977 18.5351 18.5354C17.5974 19.473 16.3257 19.9998 14.9996 19.9998Z"
                      fill="#FFE5D2"
                    />
                    <path
                      d="M23.0066 8.79287C24.0007 8.79287 24.8066 7.98698 24.8066 6.99287C24.8066 5.99876 24.0007 5.19287 23.0066 5.19287C22.0125 5.19287 21.2066 5.99876 21.2066 6.99287C21.2066 7.98698 22.0125 8.79287 23.0066 8.79287Z"
                      fill="#FFE5D2"
                    />
                  </svg>
                </SocialIcon>

                <SocialIcon href="https://www.linkedin.com/company/masks-for-docs/">
                  <svg
                    width="30"
                    height="30"
                    viewBox="0 0 30 30"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg">
                    <title>linkedin-social</title>
                    <path
                      d="M27.9996 0H1.99963C1.4692 0 0.960493 0.210714 0.58542 0.585786C0.210348 0.960859 -0.000366211 1.46957 -0.000366211 2V28C-0.000366211 28.5304 0.210348 29.0391 0.58542 29.4142C0.960493 29.7893 1.4692 30 1.99963 30H27.9996C28.5301 30 29.0388 29.7893 29.4138 29.4142C29.7889 29.0391 29.9996 28.5304 29.9996 28V2C29.9996 1.46957 29.7889 0.960859 29.4138 0.585786C29.0388 0.210714 28.5301 0 27.9996 0ZM8.88663 25.594H4.37363V11.25H8.88663V25.594ZM6.62963 9.281C6.1108 9.27942 5.60407 9.12412 5.17345 8.83472C4.74282 8.54533 4.40762 8.13481 4.21016 7.65501C4.01271 7.17522 3.96186 6.64767 4.06405 6.139C4.16624 5.63033 4.41688 5.16335 4.7843 4.79703C5.15173 4.43072 5.61948 4.18151 6.12846 4.08087C6.63744 3.98023 7.16483 4.03268 7.64402 4.23159C8.12321 4.4305 8.5327 4.76696 8.82079 5.19846C9.10888 5.62997 9.26263 6.13717 9.26263 6.656C9.26277 7.00143 9.1947 7.34349 9.06232 7.66255C8.92995 7.98161 8.73588 8.2714 8.49126 8.51528C8.24663 8.75917 7.95625 8.95235 7.63679 9.08375C7.31733 9.21515 6.97506 9.28218 6.62963 9.281ZM25.6206 25.594H21.1996V18.656C21.1996 16.969 21.1996 14.906 18.8496 14.906C16.4996 14.906 16.2166 16.688 16.2166 18.562V25.688H11.7996V11.25H15.9356V13.219H16.0296C16.4562 12.4815 17.0752 11.8738 17.8205 11.4609C18.5657 11.0481 19.4092 10.8455 20.2606 10.875C24.7736 10.875 25.6196 13.875 25.6196 17.719L25.6206 25.594Z"
                      fill="#FFE5D2"
                    />
                  </svg>
                </SocialIcon>
              </div>
            </div>
          </div>
          <Copyright className="md:hidden mt-4 justify-end" />
        </div>
      </div>
    </footer>
  )
}

const SocialIcon: React.FC<{ href: string }> = ({ children, href }) => (
  <div className="w-8 h-8 flex items-center justify-center m-2 mx-5">
    <a href={href} className="block w-6 h-6">
      {children}
    </a>
  </div>
)

const FooterIcon: React.FC = () => (
  <svg
    width="82"
    height="110"
    viewBox="0 0 82 110"
    fill="none"
    xmlns="http://www.w3.org/2000/svg">
    <path
      d="M77.9 0H4.1672C1.88195 0 0 1.88197 0 4.16722V69.9312C0 91.5066 18.4164 109.049 41 109.049C63.5836 109.049 82 91.5066 82 69.9312V4.16722C82 1.88197 80.1852 0 77.9 0Z"
      fill="white"
    />
    <path
      d="M38.5805 72.351V49.969C38.5805 49.028 38.5805 48.1542 38.5133 47.2805C38.4461 46.4067 38.3117 45.6001 38.0428 44.928C37.774 44.2559 37.4379 43.7182 37.0346 43.3149C36.5641 42.9116 35.9592 42.71 35.2871 42.71C33.8084 42.71 32.5986 43.3149 31.5904 44.5919C30.5822 45.869 29.8428 47.4149 29.3051 49.2969V72.351H24.3986V38.8116H27.7592L28.7002 42.9116H28.969C29.3723 42.2395 29.8428 41.6346 30.2461 41.0297C30.6494 40.4247 31.1199 39.887 31.6576 39.4837C32.1953 39.0133 32.8002 38.6772 33.5395 38.4755C34.2789 38.2067 35.2199 38.1395 36.2953 38.1395C36.9674 38.1395 37.6396 38.2067 38.3117 38.4083C38.9838 38.61 39.6559 38.9461 40.1936 39.3493C40.7986 39.7526 41.269 40.3575 41.7395 41.0297C42.1428 41.769 42.4789 42.6427 42.6133 43.6509C43.6215 41.9034 44.6969 40.5592 45.974 39.551C47.1838 38.5428 48.8641 38.0723 51.015 38.0723C52.4264 38.0723 53.5691 38.3411 54.4428 38.8116C55.3166 39.2821 55.9887 40.0215 56.5264 40.8952C56.9969 41.8362 57.4002 42.9116 57.5346 44.1887C57.7363 45.4657 57.8035 46.8772 57.8035 48.4231V72.351H52.8969V49.5657C52.8969 48.6247 52.8297 47.751 52.7625 46.9444C52.6953 46.1378 52.4936 45.3985 52.292 44.7936C52.0231 44.1887 51.7543 43.6509 51.351 43.3149C50.9477 42.9788 50.41 42.7772 49.6707 42.7772C48.192 42.7772 46.9149 43.3821 45.8395 44.6591C44.8313 45.9362 44.0248 47.6837 43.4871 50.0362V72.4182H38.5805V72.351Z"
      fill="black"
    />
    <path
      d="M58.5423 81.1553H23.5243C22.7849 81.1553 22.1128 81.9618 22.1128 82.97C22.1128 83.9782 22.7177 84.7848 23.5243 84.7848H58.5423C59.2816 84.7848 59.9538 83.9782 59.9538 82.97C59.9538 81.9618 59.2816 81.1553 58.5423 81.1553Z"
      fill="#ED2E69"
    />
  </svg>
)
