defmodule PhxToolsWeb.Components.SharedComponents do
  @moduledoc """
  Renders optimum logo
  """
  use PhxToolsWeb, :html

  @spec optimum_logo(map()) :: Phoenix.LiveView.Rendered.t()
  def optimum_logo(assigns) do
    ~H"""
    <svg width="156" height="101" viewBox="0 0 156 101" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M78.1366 54.5946C93.2252 54.5946 105.457 42.373 105.457 27.2973C105.457 12.2214 93.2252 0 78.1366 0C63.048 0 50.8161 12.2214 50.8161 27.2973C50.8161 42.373 63.048 54.5946 78.1366 54.5946ZM78.1366 40.9459C85.6809 40.9459 91.7968 34.8352 91.7968 27.2973C91.7968 19.7594 85.6809 13.6486 78.1366 13.6486C70.5923 13.6486 64.4764 19.7594 64.4764 27.2973C64.4764 34.8352 70.5923 40.9459 78.1366 40.9459Z"
        fill="url(#paint0_linear_13_41)"
      />
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M78.1366 0C66.8202 0 57.6462 9.16605 57.6462 20.473C57.6462 31.7798 66.8202 40.9459 78.1366 40.9459C70.5923 40.9459 64.4764 34.8352 64.4764 27.2973C64.4764 19.7594 70.5923 13.6486 78.1366 13.6486V0Z"
        fill="url(#paint1_linear_13_41)"
      />
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M78.1366 0C63.048 0 50.8161 12.2214 50.8161 27.2973C50.8161 42.373 63.048 54.5946 78.1366 54.5946V40.9459C66.8202 40.9459 57.6462 31.7798 57.6462 20.473C57.6462 9.16605 66.8202 0 78.1366 0Z"
        fill="url(#paint2_linear_13_41)"
      />
      <path
        d="M10.7369 90.2722C8.95202 90.2722 7.31279 89.8537 5.81926 89.0165C4.32573 88.1793 3.14185 87.0238 2.2676 85.5498C1.39334 84.0574 0.956215 82.3743 0.956215 80.4998C0.956215 78.6436 1.39334 76.9784 2.2676 75.5044C3.14185 74.012 4.32573 72.8475 5.81926 72.0103C7.31279 71.1731 8.95202 70.7546 10.7369 70.7546C12.5401 70.7546 14.1793 71.1731 15.6546 72.0103C17.1482 72.8475 18.3229 74.012 19.179 75.5044C20.0532 76.9784 20.4904 78.6436 20.4904 80.4998C20.4904 82.3743 20.0532 84.0574 19.179 85.5498C18.3229 87.0238 17.1482 88.1793 15.6546 89.0165C14.1611 89.8537 12.5219 90.2722 10.7369 90.2722ZM10.7369 86.86C11.8844 86.86 12.8953 86.6054 13.7695 86.0957C14.6438 85.5681 15.3268 84.8218 15.8186 83.8573C16.3103 82.8929 16.5562 81.7737 16.5562 80.4998C16.5562 79.2258 16.3103 78.1159 15.8186 77.1695C15.3268 76.2051 14.6438 75.4681 13.7695 74.9584C12.8953 74.4488 11.8844 74.1941 10.7369 74.1941C9.58949 74.1941 8.56953 74.4488 7.67706 74.9584C6.8028 75.4681 6.11979 76.2051 5.62802 77.1695C5.13625 78.1159 4.89037 79.2258 4.89037 80.4998C4.89037 81.7737 5.13625 82.8929 5.62802 83.8573C6.11979 84.8218 6.8028 85.5681 7.67706 86.0957C8.56953 86.6054 9.58949 86.86 10.7369 86.86ZM41.6135 76.9238C41.6135 77.9428 41.3676 78.8982 40.8758 79.79C40.4021 80.6818 39.6464 81.4006 38.6082 81.9465C37.5881 82.4925 36.295 82.7654 34.7287 82.7654H31.5322V90.0811H27.7073V71.0276H34.7287C36.204 71.0276 37.4608 71.2823 38.4989 71.7919C39.5371 72.3016 40.3111 73.002 40.8212 73.8938C41.3493 74.7856 41.6135 75.7956 41.6135 76.9238ZM34.5648 79.6808C35.621 79.6808 36.4043 79.4442 36.9143 78.9711C37.4241 78.4798 37.6793 77.7973 37.6793 76.9238C37.6793 75.0676 36.6411 74.1395 34.5648 74.1395H31.5322V79.6808H34.5648ZM61.6774 71.0276V74.1122H56.5958V90.0811H52.7709V74.1122H47.6893V71.0276H61.6774ZM72.6643 71.0276V90.0811H68.8394V71.0276H72.6643ZM101.605 71.0276V90.0811H97.7806V77.6882L92.6716 90.0811H89.7757L84.6394 77.6882V90.0811H80.8146V71.0276H85.1585L91.2237 85.1949L97.2888 71.0276H101.605ZM113.529 71.0276V82.82C113.529 84.112 113.866 85.104 114.54 85.7954C115.213 86.4689 116.16 86.8054 117.381 86.8054C118.619 86.8054 119.575 86.4689 120.249 85.7954C120.923 85.104 121.26 84.112 121.26 82.82V71.0276H125.113V82.7927C125.113 84.4123 124.757 85.7864 124.047 86.9146C123.355 88.0248 122.417 88.8618 121.233 89.426C120.067 89.9902 118.765 90.2722 117.326 90.2722C115.906 90.2722 114.612 89.9902 113.447 89.426C112.299 88.8618 111.388 88.0248 110.715 86.9146C110.041 85.7864 109.704 84.4123 109.704 82.7927V71.0276H113.529ZM153.97 71.0276V90.0811H150.145V77.6882L145.036 90.0811H142.14L137.004 77.6882V90.0811H133.179V71.0276H137.523L143.588 85.1949L149.653 71.0276H153.97Z"
        fill="white"
      />
      <defs>
        <linearGradient
          id="paint0_linear_13_41"
          x1="50.8161"
          y1="27.2973"
          x2="120.132"
          y2="27.2973"
          gradientUnits="userSpaceOnUse"
        >
          <stop stop-color="#5433FF" />
          <stop offset="0.5" stop-color="#20BDFF" />
          <stop offset="1" stop-color="#A5FECB" />
        </linearGradient>
        <linearGradient
          id="paint1_linear_13_41"
          x1="78.1366"
          y1="14.4676"
          x2="68.588"
          y2="35.902"
          gradientUnits="userSpaceOnUse"
        >
          <stop stop-color="#4951FF" stop-opacity="0" />
          <stop offset="1" stop-color="#4951FF" />
        </linearGradient>
        <linearGradient
          id="paint2_linear_13_41"
          x1="50.4063"
          y1="21.063"
          x2="78.132"
          y2="40.0381"
          gradientUnits="userSpaceOnUse"
        >
          <stop stop-color="#28177E" />
          <stop offset="1" stop-color="#2A66CB" stop-opacity="0" />
        </linearGradient>
      </defs>
    </svg>
    """
  end
end
