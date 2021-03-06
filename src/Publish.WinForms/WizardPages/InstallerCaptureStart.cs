// Copyright Bastian Eicher et al.
// Licensed under the GNU Lesser Public License

using System;
using System.IO;
using AeroWizard;
using NanoByte.Common;
using NanoByte.Common.Tasks;
using ZeroInstall.Publish.Capture;
using ZeroInstall.Publish.WinForms.Properties;

namespace ZeroInstall.Publish.WinForms
{
    partial class NewFeedWizard
    {
        private void pageInstallerCaptureStart_Commit(object sender, WizardPageConfirmEventArgs e)
        {
            try
            {
                var captureSession = CaptureSession.Start(_feedBuilder);

                using (var handler = new DialogTaskHandler(this))
                    _installerCapture.RunInstaller(handler);

                _installerCapture.CaptureSession = captureSession;
            }
            #region Error handling
            catch (OperationCanceledException)
            {
                e.Cancel = true;
            }
            catch (IOException ex)
            {
                e.Cancel = true;
                Msg.Inform(this, ex.Message, MsgSeverity.Warn);
            }
            catch (UnauthorizedAccessException ex)
            {
                e.Cancel = true;
                Msg.Inform(this, ex.Message, MsgSeverity.Warn);
            }
            catch (InvalidOperationException ex)
            {
                e.Cancel = true;
                Msg.Inform(this, ex.Message, MsgSeverity.Error);
            }
            #endregion
        }

        private void buttonSkipCapture_Click(object sender, EventArgs e)
        {
            if (!Msg.YesNo(this, Resources.AskSkipCapture, MsgSeverity.Info)) return;

            try
            {
                using var handler = new DialogTaskHandler(this);
                _installerCapture.ExtractInstallerAsArchive(_feedBuilder, handler);
            }
            #region Error handling
            catch (OperationCanceledException)
            {
                return;
            }
            catch (IOException ex)
            {
                Msg.Inform(this, Resources.InstallerExtractFailed + Environment.NewLine + ex.Message, MsgSeverity.Warn);
                return;
            }
            catch (UnauthorizedAccessException ex)
            {
                Msg.Inform(this, ex.Message, MsgSeverity.Error);
                return;
            }
            #endregion

            wizardControl.NextPage(pageArchiveExtract, skipCommit: true);
        }
    }
}
