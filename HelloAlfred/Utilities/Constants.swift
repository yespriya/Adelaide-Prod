
import Foundation
import UIKit


struct DataService
{
   // static let developmentBaseURL = "https://testingappspr.azurewebsites.net/"
//    static let developmentBaseURL = "https://test.api.helloalfred.ai/"
//    static let developmentBaseURL = "https://dev.api.helloalfred.ai/"
//    static let developmentBaseURL = "https://dev-v1.helloalfred.ai/"
  //  static let developmentBaseURL = "https://dev.api.helloalfred.ai/"
    
    static let developmentBaseURL = "https://api.adelaide.helloalfred.ai"
}

public struct Constants {
    static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

   static let termsAndPolicy = """
<!DOCTYPE html>\n
<html lang=\"en\">
   \n
   <head>
      \n 
      <meta charset=\"UTF-8\">
      \n 
      <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
      \n 
      <title>Terms and Conditions</title>
      \n 
      <style>\n body {\n font-family: Arial, sans-serif;\n line-height: 1.6;\n margin: 20px;\n padding: 0;\n }\n h1, h2, h3 {\n color: #333;\n }\n h1 {\n text-align: center;\n }\n p {\n margin: 1em 0;\n }\n ul {\n margin: 0;\n padding-left: 20px;\n }\n </style>
      \n
   </head>
   \n
   <body>
      \n 
      <h1>HelloAlfred Web or Digital App Terms of Use</h1>
      \n 
      <p>Last Updated: 6/16/24</p>
      \n 
      <h2>1. Acceptance of Terms</h2>
      \n 
      <p>By creating an account or using the App, you confirm that you are at least 18 years old and capable of entering into a legally binding agreement. If you are under 18, you must have the permission of a parent or guardian to use the App.</p>
      \n 
      <h2>2. Privacy Policy</h2>
      \n 
      <p>Your privacy is important to us. Please review our <a href=\"https://adelaide.helloalfred.ai/#/privacypolicy\">Privacy Policy</a>, which explains how we collect, use, and share your information.</p>
      \n 
      <h2>3. Use of the App</h2>
      \n 
      <p><strong>3.1 Personal Use:</strong> The App is provided for your personal, non-commercial use only.</p>
      \n 
      <p><strong>3.2 Prohibited Activities:</strong> You agree not to:</p>
      \n 
      <ul>
         \n 
         <li>Use the App for any illegal purpose.</li>
         \n 
         <li>Violate any applicable local, state, national, or international law.</li>
         \n 
         <li>Engage in any activity that could harm or interfere with the operation of the App.</li>
         \n 
         <li>Attempt to gain unauthorized access to any part of the App or its systems.</li>
         \n 
         <li>Use the App to distribute viruses or other harmful software.</li>
         \n 
      </ul>
      \n 
      <h2>4. Health Information</h2>
      \n 
      <p><strong>4.1 Not Medical Advice:</strong> The App provides health-related information but is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.</p>
      \n 
      <p><strong>4.2 Accuracy of Information:</strong> While we strive to provide accurate and up-to-date information, we cannot guarantee the accuracy, completeness, or timeliness of any information provided through the App.</p>
      \n 
      <h2>5. User Content</h2>
      \n 
      <p><strong>5.1 Ownership:</strong> You retain ownership of any content you post or upload to the App (\"User Content\"). By posting User Content, you grant us a non-exclusive, royalty-free, worldwide, transferable, and sublicensable license to use, reproduce, modify, display, and distribute your User Content in connection with the App.</p>
      \n 
      <p><strong>5.2 Prohibited Content:</strong> You agree not to post any User Content that:</p>
      \n 
      <ul>
         \n 
         <li>Is false, misleading, or fraudulent.</li>
         \n 
         <li>Is defamatory, obscene, offensive, or otherwise objectionable.</li>
         \n 
         <li>Infringes the rights of any third party, including intellectual property rights.</li>
         \n 
         <li>Contains personal information of another person without their consent.</li>
         \n 
      </ul>
      \n 
      <h2>6. Data Use and Rights</h2>
      \n 
      <p><strong>6.1 Data Collection:</strong> We collect various types of information in connection with your use of the App, including personal information and health-related data. This information is collected in accordance with our Privacy Policy.</p>
      \n 
      <p><strong>6.2 Data Use:</strong> The data we collect is used to provide and improve the App, customize your user experience, communicate with you, and for other purposes described in our Privacy Policy. We may also use aggregated and anonymized data for research and analytics purposes.</p>
      \n 
      <p><strong>6.3 Data Sharing:</strong> We do not sell your personal information. We may share your data with third parties as described in our Privacy Policy, including with service providers who assist us in operating the App and with healthcare professionals if you choose to share your information with them.</p>
      \n 
      <p><strong>6.4 Data Security:</strong> We implement appropriate technical and organizational measures to protect your data against unauthorized access, alteration, disclosure, or destruction. However, no security measures are completely foolproof, and we cannot guarantee the security of your data.</p>
      \n 
      <p><strong>6.5 Data Rights:</strong> Depending on your jurisdiction, you may have certain rights regarding your data, including the right to access, correct, delete, or restrict the use of your data. You may also have the right to object to the processing of your data or to request data portability. To exercise these rights, please contact us at [Contact Information].</p>
      \n 
      <h2>7. Artificial Intelligence Use</h2>
      \n 
      <p><strong>7.1 AI Functionality:</strong> The App may use artificial intelligence (AI) technologies to provide certain features and functionalities, such as personalized recommendations, health assessments, and data analysis.</p>
      \n 
      <p><strong>7.2 AI Data Use:</strong> Data processed by our AI systems may include personal and health-related information. This data is used to improve the accuracy and effectiveness of our AI-driven features and to enhance your user experience.</p>
      \n 
      <p><strong>7.3 Limitations of AI:</strong> While our AI technologies are designed to assist and enhance your use of the App, they are not infallible. AI-generated insights and recommendations are not a substitute for professional medical advice, diagnosis, or treatment. Always consult with a qualified healthcare provider before making decisions based on AI-generated information.</p>
      \n 
      <p><strong>7.4 Transparency:</strong> We strive to ensure transparency in our use of AI technologies. You can learn more about how we use AI and the data involved in our Privacy Policy [Link to Privacy Policy].</p>
      \n 
      <p><strong>7.5 User Consent:</strong> By using the App, you consent to the processing of your data by our AI systems as described in these Terms and our Privacy Policy.</p>
      \n 
      <h2>8. Accounts, Passwords, and Security</h2>
      \n 
      <p><strong>8.1 Account Creation:</strong> To use certain features of the App, you may need to create an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.</p>
      \n 
      <p><strong>8.2 Account Security:</strong> You are responsible for maintaining the confidentiality of your account credentials, including your username and password, and for all activities that occur under your account. You agree to:</p>
      \n 
      <ul>
         \n 
         <li>Promptly notify us of any unauthorized use of your account or any other breach of security.</li>
         \n 
         <li>Ensure that you exit from your account at the end of each session, especially when accessing the App from a public or shared device.</li>
         \n 
      </ul>
      \n 
      <p><strong>8.3 Account Termination:</strong> We reserve the right to suspend or terminate your account at any time, without prior notice, for any reason, including if we believe you have violated these Terms. Upon termination, your right to use the App will immediately cease.</p>
      \n 
      <h2>9. Links to Other Sites and the Digital App</h2>
      \n 
      <p><strong>9.1 Third-Party Links:</strong> The App may contain links to third-party websites or services that are not owned or controlled by us. We have no control over, and assume no responsibility for, the content, privacy policies, or practices of any third-party websites or services. You acknowledge and agree that we are not responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services available on or through any such websites or services.</p>
      \n 
      <p><strong>9.2 Linking to the App:</strong> You may link to the App, provided you do so in a way that is fair and legal and does not damage our reputation or take advantage of it. You must not establish a link in such a way as to suggest any form of association, approval, or endorsement on our part where none exists. We reserve the right to withdraw linking permission without notice.</p>
      \n 
      <h2>10. Violation of the Above Terms of Use</h2>
      \n 
      <p><strong>10.1 Consequences of Violation:</strong> If you violate these Terms, we may take actions that we deem appropriate, including but not limited to:</p>
      \n 
      <ul>
         \n 
         <li>Issuing a warning.</li>
         \n 
         <li>Suspending or terminating your account.</li>
         \n 
         <li>Blocking your access to the App.</li>
         \n 
         <li>Taking legal action against you.</li>
         \n 
      </ul>
      \n 
      <p><strong>10.2 Reporting Violations:</strong> If you become aware of any misuse of the App or any violation of these Terms, please report it to us immediately at [Contact Information].</p>
      \n 
      <p><strong>10.3 Cooperation with Authorities:</strong> We reserve the right to cooperate fully with law enforcement authorities or court orders requesting or directing us to disclose the identity of anyone using the App in a manner that violates these Terms or any applicable law.</p>
      \n 
      <h2>11. Intellectual Property</h2>
      \n 
      <p>All intellectual property rights in the App, including but not limited to trademarks, service marks, logos, and copyrighted materials, are owned by us or our licensors. You agree not to use any such intellectual property without our prior written consent.</p>
      \n 
      <h2>12. Disclaimers and Limitation of Liability</h2>
      \n 
      <p><strong>12.1 Disclaimers:</strong> The App is provided \"as is\" and \"as available\" without any warranties of any kind, either express or implied. We do not warrant that the App will be uninterrupted or error-free.</p>
      \n 
      <p><strong>12.2 Limitation of Liability:</strong> To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses, resulting from:</p>
      \n 
      <ul>
         \n 
         <li>Your use of or inability to use the App.</li>
         \n 
         <li>Any unauthorized access to or use of our servers and/or any personal information stored therein.</li>
         \n 
         <li>Any errors or omissions in the App.</li>
         \n 
      </ul>
      \n 
      <h2>13. Indemnification</h2>
      \n 
      <p>You agree to indemnify, defend, and hold harmless [App Name], its affiliates, and their respective officers, directors, employees, and agents from and against any claims, liabilities, damages, losses, and expenses, including reasonable attorneys' fees, arising out of or in any way connected with your use of the App or violation of these Terms.</p>
      \n 
      <h2>14. Termination</h2>
      \n 
      <p>We may terminate or suspend your access to the App at any time, without prior notice or liability, for any reason, including if you breach these Terms. Upon termination, your right to use the App will immediately cease.</p>
      \n 
      <h2>15. Governing Law</h2>
      \n 
      <p>These Terms shall be governed by and construed in accordance with the laws of State of Texas, without regard to its conflict of law principles. Any legal action or proceeding arising under these Terms will be brought exclusively in the federal or state courts located in State of Texas.</p>
      \n 
      <p><strong>15.1. Texas-Specific Terms:</strong> Consumer Protection: These Terms are subject to the provisions of the Texas Deceptive Trade Practices-Consumer Protection Act. If any provision of these Terms conflicts with the Act, the conflicting provision shall be considered modified to the extent necessary to comply with the Act.</p>
      \n 
      <p><strong>15.2 Texas-Specific Terms:</strong> Notification: In accordance with Texas Business and Commerce Code Section 17.505, you must notify us in writing of any alleged defect or breach of these Terms and allow us 60 days to remedy the issue before initiating any legal action.</p>
      \n 
      <h2>16. Changes to Terms</h2>
      \n 
      <p>We reserve the right to modify these Terms at any time. Any changes will be effective immediately upon posting the updated Terms on the App. Your continued use of the App following the posting of changes constitutes your acceptance of those changes.</p>
      \n 
      <h2>17. Miscellaneous Terms</h2>
      \n 
      <p><strong>17.1 Entire Agreement:</strong> These Terms, together with the Privacy Policy and any other legal notices published by us on the App, constitute the entire agreement between you and us concerning your use of the App.</p>
      \n 
      <p><strong>17.2 Severability:</strong> If any provision of these Terms is found to be invalid, illegal, or unenforceable, the remaining provisions will continue in full force and effect.</p>
      \n 
      <p><strong>17.3 Waiver:</strong> Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. Any waiver of any provision of these Terms will be effective only if in writing and signed by us.</p>
      \n 
      <p><strong>17.4 Assignment:</strong> We may assign our rights and obligations under these Terms to any party at any time without notice to you. You may not assign your rights or obligations under these Terms without our prior written consent.</p>
      \n 
      <p><strong>17.5 Force Majeure:</strong> We will not be liable for any failure or delay in performance due to any cause beyond our reasonable control, including but not limited to acts of God, war, strikes, labor disputes, embargoes, government orders, or any other force majeure event.</p>
      \n 
      <h2>18. Contact Us</h2>
      \n 
      <p>If you have any questions about these Terms, please contact us at [Contact Information].</p>
      \n
   </body>
   \n
</html>
"""
}
