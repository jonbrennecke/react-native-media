using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Jonbrennecke.Farrago.RNJonbrenneckeFarrago
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNJonbrenneckeFarragoModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNJonbrenneckeFarragoModule"/>.
        /// </summary>
        internal RNJonbrenneckeFarragoModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNJonbrenneckeFarrago";
            }
        }
    }
}
